library(Rgadget)
setwd('~/gadget/gadget-models/capelin/capModel')
system.time(
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(spr.sind=c('igfs.si'),
                                      aut.sind=c('aut.si'),
                                      aco.sind=c('aco.si'),
                                      survey=c('ldist.igfs', 'aldist.igfs',
                                               'ldist.aut'),# 'aldist.aut'),
                                      comm=c('ldist.comm')), # 'aldist.comm')),
                        wgts='WGTS')
)

# grouping with age-length distribution
# survey=c('ldist.igfs', 'aldist.igfs',
#          'ldist.aut', 'aldist.aut'),
# comm=c('ldist.bmt', 'aldist.bmt')),