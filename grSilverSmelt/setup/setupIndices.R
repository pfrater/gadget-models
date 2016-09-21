## IGFS survey indices

# may want to change these to mfdb_sample_totalweight and 
# use survey biomass index instead
igfs.SI1 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type ='IGFS',
    length = mfdb_interval("len", c(12,15,18,21))),
    defaults))
# values of 15, 20, 25 worked, but fit not good

igfs.SI2 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'IGFS',
    length = mfdb_interval("len", c(21,24,27,30,33))),
    defaults))
# values of 25,30,35,40 worked fine

igfs.SI3 <- mfdb_sample_count(mdb, c( 'length'), c(list(
    sampling_type = 'IGFS',
    length = mfdb_interval("len", c(33,36,39,42,45), open_ended=T)),
    defaults))
# values of 35,40,45,55 worked fine


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.short",
                                                 weight = 1,
                                                 data = igfs.SI1[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.mid",
                                                 weight = 1,
                                                 data = igfs.SI2[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.long",
                                                 weight = 1,
                                                 data = igfs.SI3[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

## AUT survey indices
aut.SI1 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(12,15,18,21))),
    defaults))

aut.SI2 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(21,24,27,30,33))),
    defaults))

aut.SI3 <- mfdb_sample_count(mdb, c( 'length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(33,36,39,42,45), open_ended=T)),
    defaults))


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.short",
                                                 weight = 1,
                                                 data = aut.SI1[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.mid",
                                                 weight = 1,
                                                 data = aut.SI2[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.long",
                                                 weight = 1,
                                                 data = aut.SI3[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))