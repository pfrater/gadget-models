gadgetlikelihood('likelihood', gd$dir, missingOkay=T) %>%
    gadget_update('penalty',
                  name = "bounds",
                  weight = "0.5",
                  data = data.frame(
                      switch = c("default"),
                      power = c(2),
                      upperW=10000,
                      lowerW=10000,
                      stringsAsFactors = FALSE)) %>%
    gadget_update('understocking',
                  name = 'understocking',
                  weight = '100') %>%
    gadget_update('surveydistribution',
                  name = 'ldist.spr',
                  weight = 1,
                  data = ldist.igfs[[1]],
                  # parameters = quote(exp(spr.si.beta) * 0.7072256) %>%
                  #              to.gadget.formulae(),
                  # suitability = survdist_suit(stock = stocknames,
                  #                             fun = 'constant',
                  #                             params = 1),
                  stocknames = stocknames) %>%
    gadget_update('surveydistribution',
                  name = 'aldist.spr',
                  weight = 1,
                  data = aldist.igfs[[1]],
                  # parameters = quote(exp(spr.si.beta) * 0.0707215) %>%
                  #              to.gadget.formulae(),
                  # suitability = survdist_suit(stock = stocknames,
                  #                             fun = 'constant',
                  #                             params = 1),
                  stocknames = stocknames) %>%
    gadget_update('surveydistribution',
                  name = 'ldist.aut',
                  weight = 1,
                  data = ldist.aut[[1]],
                  # parameters = quote(exp(aut.si.beta) * 0.7072256) %>%
                  #              to.gadget.formulae(),
                  # suitability = survdist_suit(stock = stocknames,
                  #                             fun = 'constant',
                  #                             params = 1),
                  stocknames = stocknames) %>%
    gadget_update('surveydistribution',
                  name = 'aldist.aut',
                  weight = 1,
                  data = aldist.aut[[1]],
                  # parameters = quote(exp(aut.si.beta) * 0.0707215) %>%
                  #              to.gadget.formulae(),
                  # suitability = survdist_suit(stock = stocknames,
                  #                             fun = 'constant',
                  #                             params = 1),
                  stocknames = stocknames) %>%
    # gadget_update('catchdistribution',
    #               name = 'ldist.spr',
    #               weight = 1,
    #               data = ldist.igfs[[1]],
    #               fleetnames = c('spr'),
    #               stocknames = stocknames) %>%
    # gadget_update('catchdistribution',
    #               name = 'aldist.spr',
    #               weight = 1,
    #               data = aldist.igfs[[1]],
    #               fleetnames = c('spr'),
    #               stocknames = stocknames) %>%
    # gadget_update('catchdistribution',
    #               name = 'ldist.aut',
    #               weight = 1,
    #               data = ldist.aut[[1]],
    #               fleetnames = c('aut'),
    #               stocknames = stocknames) %>%
    # gadget_update('catchdistribution',
    #               name = 'aldist.aut',
    #               weight = 1,
    #               data = aldist.aut[[1]],
    #               fleetnames = c('aut'),
    #               stocknames = stocknames) %>%
    gadget_update('catchdistribution',
                  name = 'ldist.comm',
                  weight = 1,
                  data = ldist.comm[[1]],
                  fleetnames = c('comm'),
                  stocknames = stocknames) %>%
    gadget_update('catchdistribution',
                  name = 'aldist.comm',
                  weight = 1,
                  data = aldist.comm[[1]],
                  fleetnames = c('comm'),
                  stocknames = stocknames) %>%
    # gadget_update('catchdistribution',
    #               name = 'ldist.discards',
    #               weight = 1,
    #               data = ldist.discards[[1]],
    #               fleetnames = c('discards'),
    #               stocknames = stocknames) %>%
    # gadget_update('catchdistribution',
    #               name = 'aldist.discards',
    #               weight = 1,
    #               data = aldist.discards[[1]],
    #               fleetnames = c('discards'),
    #               stocknames = stocknames) %>%
    gadget_update('surveyindices',
                  name = 'spr.si.short',
                  weight = 1,
                  data = spr.si.short[[1]],
                  fittype = 'fixedloglinearfit',
                  slope = 1,
                  intercept = sprintf('#%s.spr.si.beta', stocknames),
                  stocknames = stocknames) %>%
    gadget_update('surveyindices',
                  name = 'spr.si.mid',
                  weight = 1,
                  data = spr.si.mid[[1]],
                  fittype = 'fixedloglinearfit',
                  slope = 1,
                  intercept = sprintf('#%s.spr.si.beta', stocknames),
                  stocknames = stocknames) %>%
    gadget_update('surveyindices',
                  name = 'spr.si.long',
                  weight = 1,
                  data = spr.si.long[[1]],
                  fittype = 'fixedloglinearfit',
                  slope = 1,
                  intercept = sprintf('#%s.spr.si.beta', stocknames),
                  stocknames = stocknames) %>%
    gadget_update('surveyindices',
                  name = 'aut.si.short',
                  weight = 1,
                  data = aut.si.short[[1]],
                  fittype = 'fixedloglinearfit',
                  slope = 1,
                  intercept = sprintf('#%s.aut.si.beta', stocknames),
                  stocknames = stocknames) %>%
    gadget_update('surveyindices',
                  name = 'aut.si.mid',
                  weight = 1,
                  data = aut.si.mid[[1]],
                  fittype = 'fixedloglinearfit',
                  slope = 1,
                  intercept = sprintf('#%s.aut.si.beta', stocknames),
                  stocknames = stocknames) %>%
    gadget_update('surveyindices',
                  name = 'aut.si.long',
                  weight = 1,
                  data = aut.si.long[[1]],
                  fittype = 'fixedloglinearfit',
                  slope = 1,
                  intercept = sprintf('#%s.aut.si.beta', stocknames),
                  stocknames = stocknames) %>%
    write.gadget.file(gd$dir)