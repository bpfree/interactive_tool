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
# Scylla serrata
ssera_import <- st_read(dsn = larval_dir, layer = "ssera_import")
ssera_export <- st_read(dsn = larval_dir, layer = "ssera_export")

# Lethrunus lentjan
llent_import <- st_read(dsn = larval_dir, layer = "llent_import")
llent_export <- st_read(dsn = larval_dir, layer = "llent_export")

# Caesio teres
ctere_import <- st_read(dsn = larval_dir, layer = "ctere_import")
ctere_export <- st_read(dsn = larval_dir, layer = "ctere_export")

# Epinephelus malabaricus
emala_import <- st_read(dsn = larval_dir, layer = "emala_import")
emala_export <- st_read(dsn = larval_dir, layer = "emala_export")

# Scarus ghobban
sghob_import <- st_read(dsn = larval_dir, layer = "sghob_import")
sghob_export <- st_read(dsn = larval_dir, layer = "sghob_export")

######################################################
######################################################

### 3. Inspecting the data
head(ssera_import)
head(ssera_export)
head(llent_import)
head(llent_export)
head(ctere_import)
head(ctere_export)
head(emala_export)
head(emala_import)
head(sghob_import)
head(sghob_export)


## 3a. Checking the CRS
crs(ssera_import)
crs(ssera_export)
crs(llent_import)
crs(llent_export)
crs(ctere_import)
crs(ctere_export)
crs(emala_export)
crs(emala_import)
crs(sghob_import)
crs(sghob_export)

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

ssera_import_clean <- import_clean_function(ssera_import) %>%
  dplyr::mutate(species = "Scylla serrata") %>%
  dplyr::relocate(species, .after = import)
llent_import_clean <- import_clean_function(llent_import) %>%
  dplyr::mutate(species = "Lethrunus lentjan") %>%
  dplyr::relocate(species, .after = import)
ctere_import_clean <- import_clean_function(ctere_import) %>%
  dplyr::mutate(species = "Caesio teres") %>%
  dplyr::relocate(species, .after = import)
emala_import_clean <- import_clean_function(emala_import) %>%
  dplyr::mutate(species = "Epinephelus malabaricus") %>%
  dplyr::relocate(species, .after = import)
sghob_import_clean <- import_clean_function(sghob_import) %>%
  dplyr::mutate(species = "Scarus ghobban") %>%
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

ssera_export_clean <- export_clean_function(ssera_export) %>%
  dplyr::mutate(species = "Scylla serrata") %>%
  dplyr::relocate(species, .after = export)
llent_export_clean <- export_clean_function(llent_export) %>%
  dplyr::mutate(species = "Lethrunus lentjan") %>%
  dplyr::relocate(species, .after = export)
ctere_export_clean <- export_clean_function(ctere_export) %>%
  dplyr::mutate(species = "Caesio teres") %>%
  dplyr::relocate(species, .after = export)
emala_export_clean <- export_clean_function(emala_export) %>%
  dplyr::mutate(species = "Epinephelus malabaricus") %>%
  dplyr::relocate(species, .after = export)
sghob_export_clean <- export_clean_function(sghob_export) %>%
  dplyr::mutate(species = "Scarus ghobban") %>%
  dplyr::relocate(species, .after = export)

######################################################
######################################################

### 5. Saving to output directory
st_write(obj = ssera_import_clean, dsn = paste0(analyze_dir, "/", "ssera_import.shp"), append = F)
st_write(obj = ssera_export_clean, dsn = paste0(analyze_dir, "/", "ssera_export.shp"), append = F)

st_write(obj = llent_import_clean, dsn = paste0(analyze_dir, "/", "llent_import.shp"), append = F)
st_write(obj = llent_export_clean, dsn = paste0(analyze_dir, "/", "llent_export.shp"), append = F)

st_write(obj = ctere_import_clean, dsn = paste0(analyze_dir, "/", "ctere_import.shp"), append = F)
st_write(obj = ctere_export_clean, dsn = paste0(analyze_dir, "/", "ctere_export.shp"), append = F)

st_write(obj = emala_import_clean, dsn = paste0(analyze_dir, "/", "emala_import.shp"), append = F)
st_write(obj = emala_export_clean, dsn = paste0(analyze_dir, "/", "emala_export.shp"), append = F)

st_write(obj = sghob_import_clean, dsn = paste0(analyze_dir, "/", "sghob_import.shp"), append = F)
st_write(obj = sghob_export_clean, dsn = paste0(analyze_dir, "/", "sghob_export.shp"), append = F)
