#######################
# Rare Interactive Tool
#######################

#############
# Mozambique
#############

#####################
# Larval connectivity
#####################

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

## 1a. Set the directories where the larval connectivity raw data are currently stored for each 
larval_dir <- "country_projects\\moz\\data\\a_raw_data\\larval_connectivity"

## 1b. setting output directories
analyze_dir <- "country_projects\\moz\\data\\c_analyze_data"


## 1c. inspect the larval connectivity directory
list.files(larval_dir)

######################################################
######################################################

### 2. load the data

## 2f. larval connectivity data
# Crab
crb_import <- st_read(dsn = larval_dir, layer = "crb_import")
crb_export <- st_read(dsn = larval_dir, layer = "crb_export")

# Emperor
emp_import <- st_read(dsn = larval_dir, layer = "emp_import")
emp_export <- st_read(dsn = larval_dir, layer = "emp_export")

# Fus
fus_import <- st_read(dsn = larval_dir, layer = "fus_import")
fus_export <- st_read(dsn = larval_dir, layer = "fus_export")

# Grouper
grp_import <- st_read(dsn = larval_dir, layer = "grp_import")
grp_export <- st_read(dsn = larval_dir, layer = "grp_export")

# Parrotfish
pfs_import <- st_read(dsn = larval_dir, layer = "pfs_import")
pfs_export <- st_read(dsn = larval_dir, layer = "pfs_export")

######################################################
######################################################

### 3. Inspecting the data
head(crb_import)
head(crb_export)
head(emp_import)
head(emp_export)
head(fus_import)
head(fus_export)
head(grp_export)
head(grp_import)
head(pfs_import)
head(pfs_export)


## 3a. Checking the CRS
crs(crb_import)
crs(crb_export)
crs(emp_import)
crs(emp_export)
crs(fus_import)
crs(fus_export)
crs(grp_export)
crs(grp_import)
crs(pfs_import)
crs(pfs_export)

######################################################
######################################################

### 4. Cleaning and preparing data

## 4a. Import data

import_clean_function <- function(data){
  
  import_data_cleaned <- data %>%
    dplyr::select(wInDeg) %>%
    dplyr::rename(import = wInDeg) %>%
    dplyr::mutate(iso3 = "MOZ") %>%
    dplyr::relocate(iso3, .after = import)
  
  return(import_data_cleaned)
}

crb_import_clean <- import_clean_function(crb_import) %>%
  dplyr::mutate(species = "Crab") %>%
  dplyr::relocate(species, .after = import)
emp_import_clean <- import_clean_function(emp_import) %>%
  dplyr::mutate(species = "Emperor") %>%
  dplyr::relocate(species, .after = import)
fus_import_clean <- import_clean_function(fus_import) %>%
  dplyr::mutate(species = "Fusilier") %>%
  dplyr::relocate(species, .after = import)
grp_import_clean <- import_clean_function(grp_import) %>%
  dplyr::mutate(species = "Grouper") %>%
  dplyr::relocate(species, .after = import)
pfs_import_clean <- import_clean_function(pfs_import) %>%
  dplyr::mutate(species = "Parrotfish") %>%
  dplyr::relocate(species, .after = import)

## 6a. Export data
export_clean_function <- function(data){
  
  export_data_cleaned <- data %>%
    dplyr::select(ScrInf) %>%
    dplyr::rename(export = ScrInf) %>%
    dplyr::mutate(iso3 = "MOZ") %>%
    dplyr::relocate(iso3, .after = export)
  
  return(export_data_cleaned)
}

crb_export_clean <- export_clean_function(crb_export) %>%
  dplyr::mutate(species = "Crab") %>%
  dplyr::relocate(species, .after = export)
emp_export_clean <- export_clean_function(emp_export) %>%
  dplyr::mutate(species = "Emperor") %>%
  dplyr::relocate(species, .after = export)
fus_export_clean <- export_clean_function(fus_export) %>%
  dplyr::mutate(species = "Fusilier") %>%
  dplyr::relocate(species, .after = export)
grp_export_clean <- export_clean_function(grp_export) %>%
  dplyr::mutate(species = "Grouper") %>%
  dplyr::relocate(species, .after = export)
pfs_export_clean <- export_clean_function(pfs_export) %>%
  dplyr::mutate(species = "Parrotfish") %>%
  dplyr::relocate(species, .after = export)

######################################################
######################################################

### 5. Saving to output directory
st_write(obj = crb_import_clean, dsn = paste0(analyze_dir, "/", "crb_import.shp"), append = F)
st_write(obj = crb_export_clean, dsn = paste0(analyze_dir, "/", "crb_export.shp"), append = F)

st_write(obj = emp_import_clean, dsn = paste0(analyze_dir, "/", "emp_import.shp"), append = F)
st_write(obj = emp_export_clean, dsn = paste0(analyze_dir, "/", "emp_export.shp"), append = F)

st_write(obj = fus_import_clean, dsn = paste0(analyze_dir, "/", "fus_import.shp"), append = F)
st_write(obj = fus_export_clean, dsn = paste0(analyze_dir, "/", "fus_export.shp"), append = F)

st_write(obj = grp_import_clean, dsn = paste0(analyze_dir, "/", "grp_import.shp"), append = F)
st_write(obj = grp_export_clean, dsn = paste0(analyze_dir, "/", "grp_export.shp"), append = F)

st_write(obj = pfs_import_clean, dsn = paste0(analyze_dir, "/", "pfs_import.shp"), append = F)
st_write(obj = pfs_export_clean, dsn = paste0(analyze_dir, "/", "pfs_export.shp"), append = F)
