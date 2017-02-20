# import capelin acoustic survey data
source('data/formatAcousticData.R')

new.areas <- unique(filter(aut.cap, !(area %in% reitmapping$GRIDCELL))$area)
    
mfdb_import_area(mdb, data.frame(
    id = (nrow(reitmapping)+1):(nrow(reitmapping)+length(new.areas)),
    name = new.areas,
    size = 28*55*cos(geo::sr2d(new.areas)$lat*pi/180)))

aco.dists <-
    aut.cap.len %>%
    select(station.id, year, month, day, gridcell, small.gridcell,
           lat, lon, length, age, nr, sex, maturity, gutted.weight) %>%
    mutate(areacell = d2sr(lat, lon),
           species = 'CAP',
           sampling_type = 'ACO',
           sex = c('M','F')[pmax(1,sex)],
           gear = 'PAS') %>%
    rename(weight = gutted.weight)

mfdb_import_survey(mdb,
                   data_source='capAcousticDists',
                   aco.dists)

cap.echo.si <- 
    aut.cap %>%
    filter(cap > 0) %>%
    rename(count = cap, areacell = area) %>%
    mutate(gear = 'PAS',
           sampling_type = 'ACO',
           species = 'CAP',
           # month for 2007 is taken from length/age data
           month = ifelse(year == 2007 & is.na(month), 11, month))

mfdb_import_survey(mdb, 
                   data_source='capAcousticSurvey',
                   cap.echo.si)
