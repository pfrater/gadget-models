## general setup for gadget model on greater silver smelt (Argentina silus)
library(plyr)
library(dplyr)
library(mfdb)


setwd('/home/pfrater/gadget/gadget-models/atlantis')

# create a gadget directory and define some defaults to use with queries below
gd <- gadget_directory('cod/codModel')
setup.d <- 'cod/setup'
mdb <- mfdb('Atlantis-Iceland')
stocknames <- 'cod'

areas <- read.csv('atlantisInfo/boxInfo.csv', header=T)
boxes <- filter(areas, boundary == 0)$box_id
#boxes <- sprintf("Box%s", filter(areas, boundary == 0)$box_id)

st.year <- 1948
end.year <- 2013
defaults <- list(   
    areacell = mfdb_group("1" = boxes),
    timestep = mfdb_timestep_quarterly,
    year = st.year:end.year,
    species = 'COD')

## Write out areafile and update mainfile with areafile location
## this currently does not work with the current schema for some reason
## mfdb_area_size does not pull any data
gadget_dir_write('cod/codModel', gadget_areafile(
     size = mfdb_area_size(mdb, defaults)[[1]],
     temperature = mfdb_temperature(mdb, defaults)[[1]]))

## Write a penalty component to the likelihood file
gadget_dir_write(gd, 
                gadget_likelihood_component("penalty",
                name = "bounds",
                weight = "0.5",
                data = data.frame(
                switch = c("default"),
                power = c(2),
                upperW=10000,
                lowerW=10000,
                stringsAsFactors = FALSE)))

gadget_dir_write(gd, 
                 gadget_likelihood_component("understocking",
                 name = "understocking",
                 weight = "100"))


source(sprintf('%s/setupFleet.R', setup.d))
source(sprintf('%s/setupModel.R', setup.d))
source(sprintf('%s/setupCatchDistribution.R', setup.d))
source(sprintf('%s/setupIndices.R', setup.d))

#file.copy(sprintf('%s/itterfitter.sh', setup.d), gd$dir)
#file.copy(sprintf('%s/run.R', setup.d), gd$dir)
file.copy(sprintf('%s/optinfofile', setup.d), gd$dir)

