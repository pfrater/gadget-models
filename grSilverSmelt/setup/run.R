library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(spr.sind=c('igfs.si.2030', 'igfs.si.3040',
                                             'igfs.si.4050+'),
                                      aut.sind=c('aut.si.2030', 
                                             'aut.si.3040', 'aut.si.4050+'),
                                      survey=c('ldist.igfs', 'aldist.igfs',
                                               'ldist.aut', 'aldist.aut'),
                                      comm=c('ldist.bmt', 'aldist.bmt')),
                        wgts='WGTS')

