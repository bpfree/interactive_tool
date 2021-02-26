#######################
# Rare Interactive Tool
#######################

#############
# Mozambique
#############

####################
# Marxan Frequency
####################

######################################################
######################################################

### 0. Preparing the environment and packages

# Clean environment
rm(list = ls())

# Preparing packages
if (!require("pacman")) install.packages("pacman")

# Load packages
pacman::p_load(berryFunctions,dplyr,raster,rgdal,sf,sp,stringr)

######################################################
######################################################

### 1. Setting up directories and loading the required data for analysis

## Make sure to copy a country's files are in the appropriate directory (managed access, coral, habitat quality, etc.)
## NOTE: This should be completed before running this code
## It will be preference if to have all the countries's data in a single main directory
## or in separate subdirectories
## Single directory will have lots of files, while separate directories will lead to have
## to setting up many directories in the code

## 1a. Set the directories where the raw planning unit data are currently stored for each 
marxan_dir <- "country_projects\\moz\\data\\a_raw_data\\marxan"

## 1b. setting output directory
analyze_dir <- "country_projects\\moz\\data\\c_analyze_data"

## 1c. inspect the directory
list.files(marxan_dir)

######################################################
######################################################

### 2. load the data

## 2a. load Marxan frequency data per managed access area
MAA_marxan <- st_read(dsn = marxan_dir, layer = "") %>% ## updated the particular managed access area
  dplyr::mutate(region = "Surigao del Norte",  ## add region and populate with the name where the managed access area is located
                maa = "Burgos") %>% ## add managed access area
  dplyr::rename(marxan_frequency = number,
                puid = PUID) %>%
  dplyr::select(region, maa, puid, marxan_frequency)



######################################################
######################################################

moz_marxan <- rbind(maa_marxan)

st_geometry(moz_marxan) <- NULL

View(moz_marxan)

write.csv(phl_marxan, file = paste0(analyze_dir, "/", "moz_marxan.csv"))
