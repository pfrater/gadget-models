## general setup for gadget model on greater silver smelt (Argentina silus)
library(mfdb)

setwd('/home/pfrater/gadget/gadget-models')

# create a gadget directory and define some defaults to use with queries below
gd <- gadget_directory('grSilverSmelt/gssModel')
file.remove(sprintf('%s/Modelfiles/fleets', gd$dir))
setup.d <- 'grSilverSmelt/setup'
mdb <- mfdb('Iceland')

reitmapping <- read.table(
    system.file("demo-data", "reitmapping.tsv", package="mfdb"),
    header=TRUE,
    as.is=TRUE)

subdiv <- c(1011, 1012, 1013, 1014, 1015, 1022, 1023, 1061,
            1071, 1081, 1082, 1091, 1092, 1093, 1094, 1095, 1101, 1132, 1141, 
            1142, 1143, 1144, 1145, 1146, 1151)

st.year <- 1970
end.year <- 2015
defaults <- list(   
    area = mfdb_group("1" = subdiv),
    timestep = mfdb_timestep_quarterly,
    year = st.year:end.year,
    species = 'GSS')

## Write out areafile and update mainfile with areafile location
gadget_dir_write(gd, gadget_areafile(
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

