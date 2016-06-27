## IGFS survey indices

igfs.SI1 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'IGFS',
    length = mfdb_interval("len", c(20,25,30))),
    defaults))
# values of 15, 20, 25 worked, but fit not good

igfs.SI2 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'IGFS',
    length = mfdb_interval("len", c(30,35,40))),
    defaults))
# values of 25,30,35,40 worked fine

igfs.SI3 <- mfdb_sample_count(mdb, c( 'length'), c(list(
    sampling_type = 'IGFS',
    length = mfdb_interval("len", c(40,45,55))),
    defaults))
# values of 35,40,45,55 worked fine


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.2030",
                                                 weight = 1,
                                                 data = igfs.SI1[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = c("gssimm","gssmat")))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.3040",
                                                 weight = 1,
                                                 data = igfs.SI2[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = c("gssimm","gssmat")))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.4055",
                                                 weight = 1,
                                                 data = igfs.SI3[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = c("gssimm","gssmat")))

## AUT survey indices

aut.SI1 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(20,25,30))),
    defaults))
# values of 15, 20, 25 worked, but fit not good

aut.SI2 <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(30,35,40))),
    defaults))
# original len values c(20,25,30,35) - worked well

aut.SI3 <- mfdb_sample_count(mdb, c( 'length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(40,45,55))),
    defaults))
# original len values c(35,40,55) - worked well


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.2030",
                                                 weight = 1,
                                                 data = aut.SI1[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = c("gssimm","gssmat")))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.3040",
                                                 weight = 1,
                                                 data = aut.SI2[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = c("gssimm","gssmat")))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.4055",
                                                 weight = 1,
                                                 data = aut.SI3[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = c("gssimm","gssmat")))