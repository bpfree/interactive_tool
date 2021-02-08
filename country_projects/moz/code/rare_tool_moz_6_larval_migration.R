#######################
# Rare Interactive Tool
#######################

#############
# Mozambique
#############

#####################
# Larval migration
#####################

######################################################
######################################################

### 0. Preparing the environment and packages

# Clean environment
rm(list = ls())

# Preparing packages
if (!require("pacman")) install.packages("pacman")

# Load packages
pacman::p_load(berryFunctions,dplyr,raster,rgdal,sf,sp, stringr)

######################################################
######################################################

### 1. Setting up directories and loading the required data for analysis

## Make sure to copy a country's files are in the appropriate directory (managed access, coral, habitat quality, etc.)
## NOTE: This should be completed before running this code
## It will be preference if to have all the countries's data in a single main directory
## or in separate subdirectories
## Single directory will have lots of files, while separate directories will lead to have
## to setting up many directories in the code

## 1a. Set the directories where the larval migration raw data are currently stored for each 
migration_dir <- "country_projects\\moz\\data\\a_raw_data\\larval_migration"

## 1b. setting output directories
analyze_dir <- "country_projects\\moz\\data\\c_analyze_data"


## 1c. inspect the larval migration directory
list.files(migration_dir)

######################################################
######################################################

### 2. load the data

## 2f. larval migration data
# Crab
crb_migration <- st_read(dsn = migration_dir, layer = "crb_larval_migration")

# Emperor
emp_migration <- st_read(dsn = migration_dir, layer = "emp_larval_migration")

# Fusilier
fus_migration <- st_read(dsn = migration_dir, layer = "fus_larval_migration")

# Grouper
grp_migration <- st_read(dsn = migration_dir, layer = "grp_larval_migration")

# Parrotfish
pfs_migration <- st_read(dsn = migration_dir, layer = "pfs_larval_migration")


######################################################
######################################################

### 3. Inspecting the data
head(crb_migration)
head(emp_migration)
head(fus_migration)
head(grp_migration)
head(pfs_migration)



## 3a. Checking the CRS
crs(crb_migration)
crs(emp_migration)
crs(fus_migration)
crs(grp_migration)
crs(pfs_migration)

######################################################
######################################################

### 4. Cleaning and preparing data

## 4a. Import data

import_clean_function <- function(data){
  
  import_data_cleaned <- data %>%
    dplyr::select(M, FromID) %>%
    dplyr::rename(import = FromID, migration = M) %>%
    dplyr::mutate(iso3 = "PHL") %>%
    dplyr::relocate(iso3, .after = import)
  
  return(import_data_cleaned)
}

crb_migration_import <- import_clean_function(crb_migration) %>%
  dplyr::mutate(species = "Crab") %>%
  dplyr::relocate(species, .after = import)
emp_migration_import <- import_clean_function(emp_migration) %>%
  dplyr::mutate(species = "Emperor") %>%
  dplyr::relocate(species, .after = import)
fus_migration_import <- import_clean_function(fus_migration) %>%
  dplyr::mutate(species = "Fusilier") %>%
  dplyr::relocate(species, .after = import)
grp_migration_import <- import_clean_function(grp_migration) %>%
  dplyr::mutate(species = "Grouper") %>%
  dplyr::relocate(species, .after = import)
pfs_migration_import <- import_clean_function(pfs_migration) %>%
  dplyr::mutate(species = "Parrotfish") %>%
  dplyr::relocate(species, .after = import)


## 6a. Export data
export_clean_function <- function(data){
  
  export_data_cleaned <- data %>%
    dplyr::select(M, ToID) %>%
    dplyr::rename(export = ToID, migration = M) %>%
    dplyr::mutate(iso3 = "PHL") %>%
    dplyr::relocate(iso3, .after = export)
  
  return(export_data_cleaned)
}

crb_migration_export <- export_clean_function(crb_migration) %>%
  dplyr::mutate(species = "Crab") %>%
  dplyr::relocate(species, .after = export)
emp_migration_export <- export_clean_function(emp_migration) %>%
  dplyr::mutate(species = "Emperor") %>%
  dplyr::relocate(species, .after = export)
fus_migration_export <- export_clean_function(fus_migration) %>%
  dplyr::mutate(species = "Fusilier") %>%
  dplyr::relocate(species, .after = export)
grp_migration_export <- export_clean_function(grp_migration) %>%
  dplyr::mutate(species = "Grouper") %>%
  dplyr::relocate(species, .after = export)
pfs_migration_export <- export_clean_function(pfs_migration) %>%
  dplyr::mutate(species = "Parrotfish") %>%
  dplyr::relocate(species, .after = export)

######################################################
######################################################

### 5. Saving to output directory
st_write(obj = crb_migration_import, dsn = paste0(analyze_dir, "/", "crb_migration_import.shp"), append = F)
st_write(obj = crb_migration_export, dsn = paste0(analyze_dir, "/", "crb_migration_export.shp"), append = F)

st_write(obj = emp_migration_import, dsn = paste0(analyze_dir, "/", "emp_migration_import.shp"), append = F)
st_write(obj = emp_migration_export, dsn = paste0(analyze_dir, "/", "emp_migration_export.shp"), append = F)

st_write(obj = fus_migration_import, dsn = paste0(analyze_dir, "/", "fus_migration_import.shp"), append = F)
st_write(obj = fus_migration_export, dsn = paste0(analyze_dir, "/", "fus_migration_export.shp"), append = F)

st_write(obj = grp_migration_import, dsn = paste0(analyze_dir, "/", "grp_migration_import.shp"), append = F)
st_write(obj = grp_migration_export, dsn = paste0(analyze_dir, "/", "grp_migration_export.shp"), append = F)

st_write(obj = pfs_migration_import, dsn = paste0(analyze_dir, "/", "pfs_migration_import.shp"), append = F)
st_write(obj = pfs_migration_export, dsn = paste0(analyze_dir, "/", "pfs_migration_export.shp"), append = F)
