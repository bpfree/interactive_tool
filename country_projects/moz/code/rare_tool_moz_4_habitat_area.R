#######################
# Rare Interactive Tool
#######################

#############
# Mozambique
#############

####################
# Habitat area
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

## 1a. Set the directories where the raw habitat area data are currently stored
eez_dir <- "country_projects\\moz\\data\\b_clean_data"

habitat_area_dir <- "country_projects\\moz\\data\\a_raw_data\\habitat_area"

mangrove_dir <- "country_projects\\moz\\data\\a_raw_data\\mangrove"
coral_dir <- "country_projects\\moz\\data\\a_raw_data\\coral_reef"
seagrass_dir <- "country_projects\\moz\\data\\a_raw_data\\seagrass"

## 1b. setting output directories
clean_dir <- "country_projects\\moz\\data\\b_clean_data"
analyze_dir <- "country_projects\\moz\\data\\c_analyze_data"
tool_dir <-"country_projects\\moz\\data\\d_tool_data"


## 1c. inspect the directories
list.files(eez_dir)

list.files(habitat_area_dir)

list.files(mangrove_dir)
list.files(coral_dir)
list.files(seagrass_dir)

######################################################
######################################################

### 2. load the data

## 2a. habitat data -- Allen Coral Atlas data 
aca_benthic <- st_read(dsn = habitat_area_dir, layer = "aca_benthic") # Allen Coral Atlas benthic data (has coral reef and seagrass data) / takes about 10 - 20 minutes to load data

## UNEP-WCMC habitat data
coral_wcmc <- st_read(dsn = coral_dir, layer = "coral_reef_wcmc") # UNEP-WCMC coral reef data
colnames(coral_wcmc)

## Global Mangrove Watch mangrove data
mangrove_gmw <- st_read(dsn = mangrove_dir, layer = "GMW_2016_v2") # Global Mangrove Watch mangrove data

## Seagrass data
moz_habitat <- st_read(dsn = seagrass_dir, layer = "mozambique_seagrass") # Mozambique seagrass
colnames(moz_habitat)

## 2b. habitat area per area of interest
moz_high_res <- st_read(dsn = habitat_area_dir, layer = "moz_high_res_habitat")

## 2d. EEZ data for the Philippines
land_eez <- st_read(dsn = eez_dir, layer = "moz_land_eez") # union of EEZ and land (will help for getting mangroves)

######################################################
######################################################

### 3. Inspect the data (classes, crs, etc.)

## 3a. Examine the top of the data
head(aca_benthic)
head(mangrove_gmw)
head(coral_wcmc)

head(moz_habitat)
head(moz_high_res)

## 3b. Inspect crs and set crs values if needed for later analyses
crs(aca_benthic)
crs(mangrove_gmw)
crs(coral_wcmc)

crs(moz_habitat)
crs(moz_high_res) # currently in UTM; will need to change to set it to be the same as the others

## 3c. Inspect the levels of habitats in data
levels(as.factor(aca_benthic$class)) # ones of importance are Coral/Algae and Seagrass
levels(as.factor(moz_high_res$Class_name)) # need to recode the levels
levels(as.factor(moz_habitat$Descriptio)) # has corals and submerged vegetation as habitat types

######################################################
######################################################

### 4. Cleaning and preparing data

## 4a. Mozambique habitat data
moz_habitat_seagrass <- moz_habitat %>%
  dplyr::rename(habitat = "Descriptio") %>%
  dplyr::filter(habitat == "Submerged Vegetation") %>%
  dplyr::mutate(habitat = recode(habitat, "Submerged Vegetation" = "Seagrass")) %>%
  dplyr::mutate(iso3 = "MOZ") %>%
  dplyr::select(iso3, habitat)

moz_habitat_coral <- moz_habitat %>%
  dplyr::rename(habitat = "Descriptio") %>%
  dplyr::filter(habitat == "Corals") %>%
  dplyr::mutate(habitat = recode(habitat, "Corals" = "Coral reefs")) %>%
  dplyr::mutate(iso3 = "MOZ") %>%
  dplyr::select(iso3, habitat)


## 4b. Mozambique high resolution data
moz_high_res_habitat <- moz_high_res %>%
  mutate(iso3 = "MOZ") %>% # add the iso3 field to the data
  rename(habitat = Class_name) %>%
  relocate(iso3, .after = habitat) %>% # move the field to occur after the Class_name field
  filter(habitat %in% c("Coral framework",
                        "Deep fore-reef slope",
                        "Deep forereef slope",
                        "Dense mangrove forest",
                        "Dense seagrass",
                        "Macroalgae and scattered corals",
                        "Patch reefs",
                        "Reef flat",
                        "Seagrass",
                        "Shallow fore-reef slope",
                        "Shallow forereef slope",
                        "Sparse mangroves",
                        "Sparse seagrass")) %>%
  mutate(habitat = recode(habitat, "Coral framework" = "Coral reef",
                          "Deep fore-reef slope" = "Coral reef",
                          "Deep forereef slope" = "Coral reef",
                          "Dense mangrove forest" = "Mangrove",
                          "Dense seagrass" = "Seagrass",
                          "Macroalgae and scattered corals" = "Coral reef",
                          "Patch reefs" = "Coral reef",
                          "Reef flat" = "Coral reef",
                          "Shallow fore-reef slope" = "Coral reef",
                          "Shallow forereef slope" = "Coral reef",
                          "Sparse mangroves" = "Mangrove",
                          "Sparse seagrass" = "Seagrass")) %>%
  dplyr::select(iso3,habitat)

moz_high_res_habitat_coral <- moz_high_res_habitat %>%
  dplyr::filter(habitat == "Coral reef")

moz_high_res_habitat_mangrove <- moz_high_res_habitat %>%
  dplyr::filter(habitat == "Mangrove")

moz_high_res_habitat_seagrass <- moz_high_res_habitat %>%
  dplyr::filter(habitat == "Seagrass")

######################################################
######################################################

### 5. Subsetting data to the EEZ and area of interest

## 5a. Mangroves found in Mozambique
moz_mangroves <- st_intersection(st_make_valid(mangrove_gmw), land_eez) %>%
  dplyr::mutate(habitat = "Mangrove") %>%
  dplyr::select(iso3, habitat)
head(moz_mangroves)

## 5b. Corals in Mozambique
moz_wcmc <- st_intersection(st_make_valid(coral_wcmc), land_eez) %>%
  dplyr::mutate(habitat = "Coral reef", iso3 = "MOZ") %>%
  dplyr::select(iso3, habitat)
head(moz_wcmc)

## 5c. Allen COral Atlas data in Mozambique
moz_aca <- st_intersection(st_make_valid(aca_benthic), st_make_valid(land_eez))

moz_aca_coral <- moz_aca %>%
  dplyr::filter(class == "Coral/Algae") %>%
  dplyr::mutate(class = recode(class, "Coral/Algae" = "Coral")) %>%
  dplyr::rename(habitat = "class")

moz_aca_seagrass <- moz_aca %>%
  dplyr::filter(class == "Seagrass") %>%
  dplyr::rename(habitat = "class")


######################################################
######################################################

### 8. Saving the data to desired directories
st_write(obj = moz_aca, dsn = paste0(habitat_area_dir, "/", "moz_aca.shp"), append = F)

st_write(obj = moz_aca_coral, dsn = paste0(clean_dir, "/", "moz_aca_coral.shp"), append = F)
st_write(obj = moz_habitat_coral, dsn = paste0(clean_dir, "/", "moz_habitat_coral.shp"), append = F)
st_write(obj = moz_wcmc, dsn = paste0(clean_dir, "/", "moz_wcmc_coral.shp"), append = F)
st_write(obj = moz_high_res_habitat_coral, dsn = paste0(clean_dir, "/", "moz_high_res_habitat_coral.shp"), append = F)

st_write(obj = moz_mangroves, dsn = paste0(clean_dir, "/", "moz_mangroves.shp"), append = F)
st_write(obj = moz_high_res_habitat_mangrove, dsn = paste0(clean_dir, "/", "moz_high_res_habitat_mangrove.shp"), append = F)

st_write(obj = moz_aca_seagrass, dsn = paste0(clean_dir, "/", "moz_aca_seagrass.shp"), append = F)
st_write(obj = moz_habitat_seagrass, dsn = paste0(clean_dir, "/", "moz_habitat_seagrass.shp"), append = F)
st_write(obj = moz_high_res_habitat_seagrass, dsn = paste0(clean_dir, "/", "moz_high_res_habitat_seagrass.shp"), append = F)
