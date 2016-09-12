## general setup for gadget model of capelin (Mallotus villosus)
library(mfdb)

setwd('/home/pfrater/gadget/gadget-models')

# create gadget directory and define defaults to use with queries below
gd <- gadget_directory('capelin/capModel')
setup.d <- 'capelin/setup'
mdb <- mfdb('Iceland')

reitmapping <- read.table(
    system.file("demo-data", "reitmapping.tsv", package="mfdb"),
    header=TRUE,
    as.is=TRUE)

subdiv <- unique(reitmapping$SUBDIVISION)

st.year <- 1960
end.year <- 2015
defaults <- list(
    area = mfdb_group("1" = subdiv),
    timestep = mfdb_timestep_quarterly,
    year = st.year:end.year,
    species = 'CAP')

## write out areafile and update mainfile with areafile location
cap.area <- gadget_areafile(
    size = mfdb_area_size(mdb, defaults)[[1]],
    temperature = mfdb_temperature(mdb, defaults)[[1]])

gadget_dir_write(gd, cap.area)


## write out penalty component to likelihood file
gadget_dir_write(gd, 
                 gadget_likelihood_component("penalty",
                 name = "bounds",
                 weight = '0.5', 
                 data = data.frame(
                     switch = c('default'),
                     power = c(2),
                     upperW = 10000,
                     lowerW = 10000,
                     stringsAsFactors = F)
                 ))

# write out understocking penalty component to likelihood file
gadget_dir_write(gd,
                 gadget_likelihood_component('understocking',
                 name = 'understocking',
                 weight = '100'))


# setup files for fleet, other likelihood components, and everything else
source(sprintf('%s/setupFleet.R', setup.d))
source(sprintf('%s/setupModel.R', setup.d))
source(sprintf('%s/setupCatchDistribution.R', setup.d))
source(sprintf('%s/setupIndices.R', setup.d))

# copy the file containing info for optimization routine
file.copy(sprintf('%s/optinfofile', setup.d), gd$dir)




