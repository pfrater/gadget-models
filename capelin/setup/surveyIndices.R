## IGFS survey indices

# import survey index from mfdb
# fix the length groups to appropriate values
igfs.si <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type ='IGFS',
    length = mfdb_interval("len", c(4,8,12,15,18,21), open_ended=T)),
    defaults))


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si",
                                                 weight = 1,
                                                 data = igfs.si[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))


## AUT survey indices

aut.si <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AUT',
    length = mfdb_interval("len", c(4,8,12,15,18), open_ended=T)),
    defaults))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si",
                                                 weight = 1,
                                                 data = aut.si[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))


## Acoustic survey indices
aco.si <- mfdb_sample_count(mdb, cols=c('length'),c(list(
    sampling_type = 'ACO'),
    defaults))
attr(aco.si[[1]], "length")$all <- c(1,25)

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aco.si",
                                                 weight = 1,
                                                 data = aco.si[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))





