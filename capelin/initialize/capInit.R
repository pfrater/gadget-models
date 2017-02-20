## code to initialize data for capelin gadget model in mfdb
library(plyr)
library(dplyr)
library(tidyr)
library(fjolst)
library(fjolstTranslate)
library(Logbooks)
library(LogbooksTranslate)
library(geo)
library(mfdb)
library(data.table)

setwd('~/gadget/models/capelin')

# create connection to MFDB database
mdb <- mfdb('iceland')

# create species and gear map tables to map Iceland codes to MFDB codes
species.key <- data.frame(species.code = 31, species = 'CAP')
mapping <- read.table('data/mapping.txt', header=T)
mapping <- rename(mapping, gear.type.iceland = veidarfaeri, gear.type.mfdb = gear)

mapping <- 
    mutate(merge(mapping, gear, by.x='gear.type.mfdb', by.y = 'id'),
           gear.type.mfdb = NULL,
           description = NULL)
mapping <- rename(mapping, gear.type = gear.type.iceland, gear = name)
mapping$gear <- as.character(mapping$gear)

# table to map gridcells to division and subdivision
reitmapping <- read.table(system.file('demo-data', 'reitmapping.tsv', package='mfdb'),
                         header=T,
                         as.is=T)

## import area definitions

mfdb_import_sampling_type(mdb, data.frame(
    id = c(1,2,3,4,5),
    name = c('SEA', 'IGFS', 'AUT', 'ACO', 'LND'),
    description = c('Sea sampling', 'Icelandic ground fish survey',
                    'Icelandic autumn survey', 'Acoustic Surveys', 'Landings')))

##########################
# Import data to mfdb
##########################
source('initialize/capCommercialCatchSamples.R') #imports comm. catch samples to mfdb
source('initialize/capAcousticSurvey.R') #imports capelin acoustic surveys to mfdb
source('initialize/capLandings.R')  #imports data for landed catch 

source('initialize/capSprSurvey.R') #imports spring IGS survey data to mfdb
source('initialize/capAutSurvey.R') #imports autumn IGS survey data to mfdb



