stocknames <- c('gssimm', 'gssmat')

## setup landings for bottom.trawls
bmt.landings <- mfdb_sample_totalweight(mdb, c('age', 'length'),
                              c(list(
                                  gear = c('BMT'),
                                  sampling_type='LND',
                                  species=defaults$species), defaults))
bmt.landings[[1]] <- rename(bmt.landings[[1]], number = total_weight)

## make the bottom trawlers fleet
bmt.fleet <- Rgadget:::make.gadget.fleet(name='bmt.comm', suitability='exponentiall50',
                                          fleet.data=bmt.landings[[1]],
                                          stocknames=stocknames)


## set up and make surveys as fleet
igfs.landings <- data.frame(year=defaults$year, step=1, number=1, area=1)
igfs.fleet <- Rgadget:::make.gadget.fleet(name='igfs', suitability='andersen',
                                            fleet.data=igfs.landings,
                                            stocknames=stocknames)

# set up and make autumn survey as fleet
aut.landings <- data.frame(year=defaults$year, step=4, number=1, area=1)
aut.fleet <- Rgadget:::make.gadget.fleet(name='aut', suitability='andersen',
                                         fleet.data=aut.landings,
                                         stocknames=stocknames)



# Rgadget:::gadget_dir_write(gd, igfs.fleet)
