#stocknames <- c('cap.imm', 'cap.mat')
stocknames <- c('capelin')

# commercial landings
comm.landings <- mfdb_sample_totalweight(mdb, c('age', 'length'),
                                         c(list(
                                             gear = c('PGT'),
                                             sampling_type = 'LND',
                                             species = defaults$species), defaults))
names(comm.landings[[1]])[names(comm.landings[[1]])=='total_weight'] <- 'number'
comm.fleet <- Rgadget:::make.gadget.fleet(name='comm', suitability='exponentiall50',
                                          fleet.data=comm.landings[[1]],
                                          stocknames=stocknames)


# set up and make spring igfs survey as fleet
igfs.landings <- data.frame(year=1985:2015, step=1, number=1, area=1)
igfs.fleet <- Rgadget:::make.gadget.fleet(name='igfs', suitability='andersenfleet',
                                          fleet.data=igfs.landings,
                                          stocknames=stocknames)

# set up and make autumn survey as fleet
aut.landings <- data.frame(year=1995:2015, step=4, number=1, area=1)
aut.fleet <- Rgadget:::make.gadget.fleet(name='aut', suitability='andersenfleet',
                                         fleet.data=aut.landings,
                                         stocknames=stocknames)

# acoustic survey fleet
aco.landings <- data.frame(year=2000:2012, step=1, number=1, area=1)
aco.fleet <- Rgadget:::make.gadget.fleet(name='aco', suitability='straightline',
                                         fleet.data=aco.landings,
                                         stocknames=stocknames)