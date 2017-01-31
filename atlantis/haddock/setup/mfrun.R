library(Rgadget)
setwd('~/gadget/atlantis/haddock/hadModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                            main='main',
                        grouping=list(short=c('igfs.si.short', 'aut.si.short'),
                                      long=c('igfs.si.long', 'aut.si.long')),
                        wgts='WGTS')


# survey=c('ldist.igfs', 'ldist.aut',
#          'aldist.igfs', 'aldist.aut'),
# comm=c('ldist.bmt', 'aldist.bmt')
