library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
system.time(
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(spr.sind=c('igfs.si.2030', 'igfs.si.3040',
                                             'igfs.si.4050+'),
                                      aut.sind=c('aut.si.2030', 
                                             'aut.si.3040', 'aut.si.4050+'),
                                      survey=c('ldist.igfs', 'ldist.aut'),
                                      comm=c('ldist.bmt')),
                        wgts='WGTS')
)

# grouping with age-length distribution
# survey=c('ldist.igfs', 'aldist.igfs',
#          'ldist.aut', 'aldist.aut'),
# comm=c('ldist.bmt', 'aldist.bmt')),