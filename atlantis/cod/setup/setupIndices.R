## IGFS survey indices

spr.survey.short <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type ='SprSurvey',
    length = mfdb_interval("len", c(0,20,40))),
    defaults))

spr.survey.mid <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type ='SprSurvey',
    length = mfdb_interval("len", seq(40,80,10))),
    defaults))

spr.survey.long <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'SprSurvey',
    length = mfdb_interval("len", c(seq(80,120,10), 150), open_ended=T)),
    defaults))


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.short",
                                                 weight = 1,
                                                 data = spr.survey.short[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.mid",
                                                 weight = 1,
                                                 data = spr.survey.mid[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.long",
                                                 weight = 1,
                                                 data = spr.survey.long[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))


## AUT survey indices
aut.survey.short <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AutSurvey',
    length = mfdb_interval("len", c(0,20,40))),
    defaults))

aut.survey.mid <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AutSurvey',
    length = mfdb_interval("len", seq(40,80,10))),
    defaults))

aut.survey.long <- mfdb_sample_count(mdb, c( 'length'), c(list(
    sampling_type = 'AutSurvey',
    length = mfdb_interval("len", c(seq(80,120,10), 150), open_ended=T)),
    defaults))


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.short",
                                                 weight = 1,
                                                 data = aut.survey.short[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.mid",
                                                 weight = 1,
                                                 data = aut.survey.mid[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.long",
                                                 weight = 1,
                                                 data = aut.survey.long[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))
