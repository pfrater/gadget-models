##########################
# commercial catch samples
##########################
stations <-
    data.table(subset(translate.stodvar(),
                      sampling.type %in% c(1,8),
                      select = c(sample.id,year,month,lat,lon,
                                 gear.type,depth,gridcell))) %>%
    left_join(data.table(mapping)) %>%
    group_by(sample.id) %>%
    mutate(areacell = ifelse(is.na(lat),
                             as.numeric(paste(gridcell,sample(1:4,1),sep='')),
                             d2sr(lat,lon)),
           sampling_type = 'SEA',
           gear.type = NULL) %>%
    filter(areacell %in% reitmapping$GRIDCELL &
               !is.na(gear))

# import length distribution from commercial catch samples
ldist <- 
    translate.all.le() %>%
    filter(sample.id %in% stations$sample.id &
               species.code %in% species.key$species.code) %>%
    group_by(sample.id, species.code) %>%
    left_join(stations) %>%
    left_join(species.key) %>%
    left_join(translate.all.nu()) %>%
    mutate(count=round(count*pmax(number.counted+number.measured,1,na.rm=TRUE)/
                           pmax(1,number.measured,na.rm=TRUE))) %>%
    ungroup() %>%
    mutate(number.measured = NULL,
           number.counted = NULL,
           catch=NULL,
           station.wt = NULL,
           species.code = NULL,
           gear.type = NULL)
    
ldist <- data.table(ldist)

mfdb_import_survey(mdb,
                   data_source = 'capLdistComm',
                   ldist)

rm(ldist)

# import age-length frequencies from commercial catch samples
aldist <-
    translate.all.kv() %>%
    filter(sample.id %in% stations$sample.id & 
               species.code %in% species.key$species.code) %>%
    group_by(sample.id, species.code) %>%
    left_join(stations) %>%
    left_join(species.key) %>%
    mutate(count = 1,
           sex = c('M', 'F')[pmax(1,sex)],
           maturity_stage = pmax(1,pmin(maturity,2))) %>%
    ungroup() %>%
    filter(!is.na(areacell)) %>%
    rename(weight = ungutted.wt)

aldist <- data.table(aldist)

mfdb_import_survey(mdb,
                   data_source = 'capAldistComm',
                   aldist)
rm(aldist)
