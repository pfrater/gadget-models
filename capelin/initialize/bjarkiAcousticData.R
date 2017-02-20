# import capelin acoustic survey data
tmp <- new.env()
load('data/capelinAcousticSurveys.RData', envir=tmp)

# pythagoras <- function(a,b) {
#     sqrt((a^2) + (b^2))
# }
# 
# # compute the overall distance for each trip in meters
# for (dataset in ls(tmp)) {
#     temp.ds <- mget(dataset, envir=tmp)[[1]];
#     lats <- temp.ds$lat[1:(nrow(temp.ds)-1)];
#     lons <- temp.ds$lon[1:(nrow(temp.ds)-1)]
#     post.lats <- temp.ds$lat[2:nrow(temp.ds)];
#     post.lons <- temp.ds$lon[2:nrow(temp.ds)];
#     y.meters <- (post.lats-lats)*(111320); 
#     x.meters <- (post.lons-lons)*(111320*cos(post.lats*(pi/180)));
#     trip.distance <- pythagoras(x.meters, y.meters);
#     trip.distance <- c(NA, trip.distance);
#     temp.ds$trip.distance <- trip.distance;
#     assign(dataset, temp.ds, envir=tmp)
# }

tmp$rep12.2[15] <- NULL
cap.dat <- ldply(tmp, function(x) x)
cap.dat$sa[cap.dat$sa == -9999] <- NA
cap.dat$year <- gsub('rep', '', cap.dat$.id) %>% substr(1,2) %>% 
    paste('20', ., sep='') %>% as.numeric()
cap.dat$areacell <- d2sr(cap.dat$lat, cap.dat$lon)

# formatting the cap.dat date column - it's a mess
cap.dat <-
    mutate(cap.dat, newdate = ifelse(is.na(date), 0,
                                ifelse(grepl('\\.', date) & nchar(date)==8,
                                date,
                                ifelse(nchar(date)==10,
                                   substr(date, 3, 10),
                                   gsub('^(.{2})(.{2})(.*)$', '\\1.\\2.\\3', 
                                        substr(date, 3, 8)))))) %>%
    mutate(month = as.numeric(substr(newdate, 4, 6)))
cap.dat$month[is.na(cap.dat$month)] <- 1


cap.echo.si <-
    select(cap.dat, .id, year, month, areacell, sa, lat, lon) %>%
    rename(count = sa) %>%
    mutate(sampling_type = 'ACO', 
           species = 'CAP')


mfdb_import_survey(mdb, 
                   data_source='iceland.cap.acoustic',
                   cap.echo.si)
