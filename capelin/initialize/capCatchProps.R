## using commercial catch sample to determine months and areas of catches

stations <-
    data.table(subset(translate.stodvar(),
                      sampling.type %in% c(1,8),
                      select = c(sample.id,year,month,lat,lon,gear.type,depth))) %>%
    left_join(data.table(mapping)) %>%
    group_by(sample.id) %>%
    mutate(areacell = d2sr(lat,lon),
           gear.type = NULL) %>%
    filter(areacell %in% reitmapping$GRIDCELL &
               !is.na(gear))

comm.catch <-
    translate.all.nu() %>%
    filter(sample.id %in% stations$sample.id &
               species.code %in% species.key$species.code) %>%
    left_join(stations) %>%
    mutate(count = ifelse(number.counted==1 & number.measured==0,
                          0,
                          number.counted+number.measured))
    
comm.catch.prop <-
    comm.catch %>%
    group_by(year, month, areacell) %>%
    summarize(total.catch = sum(catch, na.rm=T)) %>%
    ungroup() %>% group_by(year) %>%
    mutate(catch.prop = total.catch / sum(total.catch))
    
comm.catch.by.month <-
    comm.catch %>%
    group_by(month) %>%
    summarize(total.catch = sum(catch, na.rm=T)) %>%
    mutate(catch.prop = total.catch / sum(total.catch))

comm.catch.by.areacell <- 
    comm.catch %>%
    group_by(areacell) %>%
    summarize(total.catch = sum(catch, na.rm=T)) %>%
    mutate(catch.prop = total.catch / sum(total.catch))



    
    
    
    
    
    
    
    