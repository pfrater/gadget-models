minage <- cod[[1]]$minage
maxage <- cod[[1]]$maxage
minlength <- cod[[1]]$minlength
maxlength <- cod[[1]]$maxlength
dl <- cod[[1]]$dl

## query database to get spring length, age, maturity
ldist.spr <- 
    mfdb_sample_count(mdb, c('age', 'length'), c(list(
    sampling_type = 'SprSurvey',
    species = defaults$species,
    age = mfdb_group(all = minage:maxage),
    length = mfdb_interval("len", seq(minlength, maxlength, by = dl),
                           open_ended=c('upper', 'lower'))),
    defaults))

# ages
aldist.spr <-
    mfdb_sample_count(mdb, c('age', 'length'), c(list(
        sampling_type = 'SprSurvey',
        age = mfdb_interval('age', minage:maxage,
                            open_ended=c('upper')),
        species=defaults$species,
        length = mfdb_interval("len", seq(minlength, maxlength, by = dl),
                               open_ended=c('upper', 'lower'))),
        defaults))

# maturity
#mat.spr <- 
#    mfdb_sample_count(mdb, c('maturity_stage', 'age', 'length'), c(list(
#        sampling_type = 'SprSurvey',
#        age = mfdb_group(all = minage:maxage),
#        length = mfdb_interval('len', seq(minlength, maxlength, by=dl),
#                               open_ended=c('upper', 'lower')),
#        maturity_stage = mfdb_group(imm = 1, mat = 5)),
#    defaults))

## query database to get autumn length, age, maturity
# length
ldist.aut <- 
    mfdb_sample_count(mdb, c('age', 'length'), c(list(
        sampling_type = 'AutSurvey',
        species = defaults$species, 
        age = mfdb_group(all = minage:maxage), 
        length = mfdb_interval("len", seq(minlength, maxlength, by = dl),
                               open_ended=c('upper', 'lower'))),
        defaults))

# ages
aldist.aut <-
    mfdb_sample_count(mdb, c('age', 'length'), c(list(
        sampling_type = 'AutSurvey',
        age = mfdb_interval('age', minage:maxage,
                            open_ended=c('upper')),
        species=defaults$species,
        length = mfdb_interval("len", seq(minlength, maxlength, by = dl),
                               open_ended=c('upper', 'lower'))),
        defaults))

# # maturity
# mat.aut <- 
#     mfdb_sample_count(mdb, c('maturity_stage', 'age', 'length'), c(list(
#         sampling_type = 'AutSurvey',
#         age = mfdb_group(all = minage:maxage),
#         length = mfdb_interval('len', seq(minlength, maxlength, by=dl),
#                                open_ended=c('upper', 'lower')),
#         maturity_stage = mfdb_group(imm = 1, mat = 5)),
#         defaults))


## query database to get commercial length, age, maturity
# length
ldist.comm <- 
    mfdb_sample_count(mdb, c('age', 'length'), c(list(
        sampling_type = 'CommSurvey',
        species = defaults$species,
        age = mfdb_group(all = minage:maxage), 
        gear = c('BMT'),
        length = mfdb_interval("len", seq(minlength, maxlength, by = dl),
                               open_ended=c('upper', 'lower'))),
        defaults))


# ages
aldist.comm <-
    mfdb_sample_count(mdb, c('age', 'length'), c(list(
        sampling_type = 'CommSurvey',
        gear = 'BMT',
        age = mfdb_interval('age', minage:maxage,
                            open_ended = c('upper')),
        length = mfdb_interval("len", seq(minlength, maxlength, by = dl),
                               open_ended=c('upper', 'lower'))),
        defaults))

# # maturity
# mat.comm <- 
#     mfdb_sample_count(mdb, c('maturity_stage', 'age', 'length'), c(list(
#         sampling_type = 'CommSurvey',
#         age = mfdb_group(all = minage:maxage),
#         length = mfdb_interval('len', seq(minlength, maxlength, by=dl),
#                               open_ended=c('upper', 'lower')),
#         maturity_stage = mfdb_group(imm = 1, mat = 5)),
#         defaults))


#######################################################################
## the following is to set up catchdistribution components for discards
#######################################################################
# ## query database to get discard length, age, maturity
# # length
# ldist.discards <- 
#     mfdb_sample_count(mdb, c('age', 'length'), c(list(
#         sampling_type = 'DiscardSurvey',
#         species = defaults$species,
#         age = mfdb_group(all = minage:maxage),
#         gear = c('BMT'),
#         length = mfdb_interval("len", seq(0, maxlength, by = 1))),
#         defaults))
# 
# # age
# aldist.discards <-
#     mfdb_sample_count(mdb, c('age', 'length'), c(list(
#         sampling_type = 'DiscardSurvey',
#         gear = 'BMT',
#         age = mfdb_step_interval('age',by=1,from=0,to=19),
#         length = mfdb_interval("len", seq(0, maxlength, by = 1))),
#         defaults))
#
# # maturity
# mat.discards <- 
#     mfdb_sample_count(mdb, c('maturity_stage', 'age', 'length'), c(list(
#         sampling_type = 'DiscardSurvey',
#         age = mfdb_group(all = minage:maxage),
#         length = mfdb_interval('len', seq(minlength, maxlength, by=dl),
#                                open_ended=c('upper', 'lower')),
#         maturity_stage = mfdb_group(imm = 1, mat = 5)),
#         defaults))

