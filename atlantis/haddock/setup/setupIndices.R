# ## setting up a tracer index to see how gadget fits to exact numbers
# tracer <- mfdb_sample_count(mdb, c('length'), c(list(
#     sampling_type='Bio'),
#     defaults))
# 
# gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
#                                                  name = "tracer",
#                                                  weight = 1e09,
#                                                  data = tracer[[1]],
#                                                  fittype = 'fixedlinearfit',
#                                                  slope=1,
#                                                  intercept=0,
#                                                  stocknames = stocknames))

## IGFS survey indices

spr.survey.short <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type ='SprSurvey',
    length = mfdb_interval("len", c(10,20,30,40,50))),
    defaults))

spr.survey.long <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type ='SprSurvey',
    length = mfdb_interval("len", c(50,60,70,100), open_ended=T)),
    defaults))

# spr.survey.long <- mfdb_sample_count(mdb, c('length'), c(list(
#     sampling_type = 'SprSurvey',
#     length = mfdb_interval("len", seq(80,120,10), open_ended=T)),
#     defaults))


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "igfs.si.short",
                                                 weight = 1,
                                                 data = spr.survey.short[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

# gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
#                                                  name = "igfs.si.mid",
#                                                  weight = 1,
#                                                  data = spr.survey.mid[[1]],
#                                                  fittype = 'fixedslopeloglinearfit',
#                                                  slope=1,
#                                                  stocknames = stocknames))

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
    length = mfdb_interval("len", c(10,20,30,40,50))),
    defaults))

aut.survey.long <- mfdb_sample_count(mdb, c('length'), c(list(
    sampling_type = 'AutSurvey',
    length = mfdb_interval("len", c(50,60,70,100), open_ended=T)),
    defaults))

# aut.survey.long <- mfdb_sample_count(mdb, c( 'length'), c(list(
#     sampling_type = 'AutSurvey',
#     length = mfdb_interval("len", seq(80,120,10), open_ended=T)),
#     defaults))


gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.short",
                                                 weight = 1,
                                                 data = aut.survey.short[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))

# gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
#                                                  name = "aut.si.mid",
#                                                  weight = 1,
#                                                  data = aut.survey.mid[[1]],
#                                                  fittype = 'fixedslopeloglinearfit',
#                                                  slope=1,
#                                                  stocknames = stocknames))

gadget_dir_write(gd, gadget_likelihood_component("surveyindices",
                                                 name = "aut.si.long",
                                                 weight = 1,
                                                 data = aut.survey.long[[1]],
                                                 fittype = 'fixedslopeloglinearfit',
                                                 slope=1,
                                                 stocknames = stocknames))
