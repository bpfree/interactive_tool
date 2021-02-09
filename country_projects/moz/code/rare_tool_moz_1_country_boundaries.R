#######################
# Rare Interactive Tool - testing
#######################

#############
# Mozambique
#############

####################
# Country boundaries
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

## 1a. Set the directories where the raw country and EEZ data are currently stored for each 
country_dir <- "country_projects\\moz\\data\\a_raw_data\\country\\gadm36_levels.gpkg"
eez_dir <- "country_projects\\moz\\data\\a_raw_data\\country"

## 1b. setting output directory
clean_dir <- "country_projects\\moz\\data\\b_clean_data"
tool_dir <-"country_projects\\moz\\data\\d_tool_data"

## 1c. inspect the directories
list.files(country_dir)
list.files(eez_dir)

### 2. load the data

## 2a. load administrative boundary data
country <- st_read(dsn = country_dir, layer = "level0") # GADM country boundary data at the national level
land_eez <- st_read(dsn = eez_dir, layer = "EEZ_Land_v3_202030") # union of EEZ and land (will help for getting mangroves)


######################################################
######################################################

### 3. Inspect the data (classes, crs, etc.)

## 3a. Examine the top of the data
head(country)
head(land_eez)

## 3b. Inspect crs and set crs values if needed for later analyses
crs(country)
crs(land_eez)

######################################################
######################################################

### 4. Filter to country(ies) of interest
moz <- country %>%
  dplyr::filter(NAME_0 == "Mozambique") %>% # Philippines national boundary
  dplyr::mutate(iso3 = "MOZ") %>%
  dplyr::select(iso3)

moz_land_eez <- land_eez %>%
  dplyr::filter(ISO_SOV1 == "MOZ")%>%
  dplyr::rename(iso3 = ISO_SOV1) %>%
  dplyr::select(iso3)

######################################################
######################################################

### 8. Export country data to compiled directory
st_write(obj = moz, dsn = paste0(tool_dir, "/", "country.shp"), append = F)
st_write(obj = moz_land_eez, dsn = paste0(clean_dir, "/", "moz_land_eez.shp"), append = F)
