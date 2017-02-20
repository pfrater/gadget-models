## read in and import landed catches

cap.landings <- 
    read.csv('data/capLandings.csv', header=T) %>% 
    rename(year = Year, total = Total, winter = Winter, summer = Summer) %>%
    mutate(iceland = wIceland + sIceland,
           others = wNorway+wFaroes+wGreenland+sNorway+sFaroes+sGreenland+sEU) %>%
    select(year, iceland, others, summer, winter)

ann.monthly.props <- 
    ldist %>%
    group_by(year, month) %>%
    summarize(nsamples = sum(count)) %>%
    group_by(year) %>%
    mutate(total = sum(nsamples)) %>%
    mutate(prop = nsamples / total)

monthly.props <- 
    data.frame(month = c(11,12,1,2,3),
               prop = c(0.05,0.20,0.35,0.35,0.05))

landedcatch <- 
    cap.landings %>%
    select(year, iceland) %>%
    filter(!is.na(iceland)) %>%
    left_join(ann.monthly.props) %>%
    mutate(total.catch = ifelse(!is.na(prop), iceland*prop, iceland),
           month = ifelse(!is.na(month), month, sample(monthly.props$month, 
                                                       prob=monthly.props$prop))) %>%
    mutate(areacell = 5112,
           sampling_type = 'LND',
           gear = 'PSE',
           weight = total.catch*1e+06, # landings are in '000 tons
           species = 'CAP') %>%
    select(-nsamples, -total, -prop, -iceland, -total.catch)

mfdb_import_survey(mdb,
                   data_source = 'capCommercialLandings',
                   landedcatch)


