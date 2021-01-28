#######################
# Rare Interactive Tool
#######################

#############
# Philippines
#############


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
pu_dir <- "data\\country\\phl\\a_raw_data\\planning_grid"

## 1b. setting output directory
clean_dir <- "data\\country\\phl\\b_clean_data"

## 1c. inspect the directory
list.files(pu_dir)

######################################################
######################################################

### 2. load the data

## 2a. load planning grid units
antique_pu <- st_read(dsn = pu_dir, layer = "antique_pu")
camotes_pu <- st_read(dsn = pu_dir, layer = "camotes_pu")
escalante_pu <- st_read(dsn = pu_dir, layer = "escalante_pu")
siargao_pu <- st_read(dsn = pu_dir, layer = "siargao_pu")


######################################################
######################################################

### 3. Inspect the data (classes, crs, etc.)

## 3a. Examine the top of the data
head(antique_pu)
head(camotes_pu)
head(escalante_pu)
head(siargao_pu)


## 3b. Inspect crs and set crs values if needed for later analyses
crs(antique_pu)
crs(camotes_pu)
crs(escalante_pu)
crs(siargao_pu)

######################################################
######################################################

### 4. Cleaning and preparing data

## 4a. Philippines planning unit

## Function to clean the planning units
planning_unit_clean <- function(data){
  pu_clean <- data %>%
    dplyr::mutate(region = "escalante") %>% ## update region name before running for Camotes, Escalante City, Siargao
    dplyr::mutate(iso3 = "PHL") %>%
    dplyr::rename(puid = PUID) %>%
    dplyr::select(puid,region,iso3)
  return(pu_clean)
}

# Antique planning units
antique_pu_clean <- antique_pu %>%
  dplyr::mutate(region = "antique") %>%
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::rename(puid = PUID) %>%
  dplyr::select(-FID_1)

# Camotes planning units
camotes_pu_clean <- planning_unit_clean(camotes_pu)

# Escalante planning units
escalante_pu_clean <- planning_unit_clean(escalante_pu)

# Siargao planning units
siargao_pu_clean <- planning_unit_clean(siargao_pu)

# combined all planning units
# phl_pu <- rbind(antique_pu_clean,
#                 camotes_pu_clean,
#                 escalante_pu_clean,
#                 siargao_pu_clean)

######################################################
######################################################

### 8. Saving to compiled directory
# st_write(obj = phl_pu, dsn = paste0(clean_dir, "/", "phl_pu.shp"), append = F)

st_write(obj = antique_pu_clean, dsn = paste0(clean_dir, "/", "antique_pu.shp"), append = F)
st_write(obj = camotes_pu_clean, dsn = paste0(clean_dir, "/", "camotes_pu.shp"), append = F)
st_write(obj = escalante_pu_clean, dsn = paste0(clean_dir, "/", "escalante_pu.shp"), append = F)
st_write(obj = siargao_pu_clean, dsn = paste0(clean_dir, "/", "siargao_pu.shp"), append = F)
