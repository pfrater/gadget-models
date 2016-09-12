## read in and import landed catches

cap.landings <- 
    read.csv('data/capLandings.csv', header=T) %>% 
    rename(year = Year, total = Total, winter = Winter, summer = Summer)

landedcatch <- 
    cap.landings %>%
    select(year, total) %>%
    filter(!is.na(total)) %>%
    mutate(month = 2,
           areacell = 5112,
           sampling_type = 'LND',
           gear = 'PGT',
           weight = total*1e+06, # landings are in '000 tons
           species = 'CAP')

mfdb_import_survey(mdb,
                   data_source='capelin.landings',
                   landedcatch)


