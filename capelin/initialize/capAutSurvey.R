##########################
# autumn survey
##########################

stations <-
    subset(translate.stodvar(), sampling.type == 35, ## autumn survey 30
           select = c(sample.id,year,month,lat,lon,gear.type,depth)) %>%
    left_join(mapping) %>%
    group_by(sample.id) %>%
    mutate(month = 10,
           areacell = d2sr(lat,lon),
           sampling_type = 'AUT') %>%
    filter(!is.na(areacell))

# Import length distribution from autumn survey
ldist <- translate.all.le() %>%
    filter(sample.id %in% stations$sample.id &
               species.code %in% species.key$species.code) %>%
    group_by(sample.id,species.code) %>%
    left_join(stations) %>%
    left_join(species.key) %>%
    left_join(translate.all.nu()) %>%
    mutate(count=round(count*pmax(number.counted+number.measured,1,na.rm=TRUE)/
                           pmax(1,number.measured,na.rm=TRUE)),
           sex = c('M','F')[pmax(1,sex)],
           sampling_type='AUT',
           age = 0,
           maturity_stage = pmax(1,pmin(maturity,2))) %>%
    ungroup() %>%
    mutate(number.measured = NULL,
           number.measured = NULL,
           catch=NULL,
           station.wt = NULL,
           species.code = NULL,
           gear.type = NULL)

ldist <- data.table(ldist)

mfdb_import_survey(mdb,
                   data_source = 'iceland.cap.ldist.aut',
                   ldist)
rm(ldist)


# import age-length frequencies from the autumn survey
aldist <- translate.all.kv() %>%
    filter(sample.id %in% stations$sample.id &
               species.code %in% species.key$species.code) %>%
    group_by(sample.id, species.code) %>%
    left_join(stations) %>%
    left_join(species.key) %>%
    mutate(count=1,
           areacell = d2sr(lat,lon),
           sex = c('M','F')[pmax(1,sex)],
           month = 10,
           sampling_type='AUT',
           maturity_stage = pmax(1,pmin(maturity,2))) %>%
    filter(!is.na(areacell)) %>%
    ungroup() %>%
    mutate(maturity=NULL,
           species.code = NULL,
           gear.type = NULL) %>%
    rename(weight = ungutted.wt)

aldist <- data.table(aldist)

mfdb_import_survey(mdb,
                   data_source = 'iceland.cap.aldist.aut',
                   aldist)
rm(aldist)

