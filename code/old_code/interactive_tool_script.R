#######################
# Rare Interactive Tool
#######################


### 0. Preparing the environment and packages

# Clean environment
rm(list = ls())

# Preparing packages
if (!require("pacman")) install.packages("pacman")

# Load packages
pacman::p_load(dplyr,raster,rgdal,sf,sp)

######################################################
######################################################

### 1. Setting up directories and loading the required data for analysis

## Make sure to copy a country's files are in the appropriate directory (managed access, coral, habitat quality, etc.)
## NOTE: This should be completed before running this code
## It will be preference if to have all the countries's data in a single main directory
  ## or in separate subdirectories
## Single directory will have lots of files, while separate directories will lead to have
  ## to setting up many directories in the code

## 1a. Set the directories where the raw data are currently stored for each 
country_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\country\\gadm36_levels.gpkg"
managed_access_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\managed_access_areas"
reserve_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\existing_reserve"
habitat_quality_dir <- "G:\Shared drives\FF Portal\GIS\interactive_tool\a_raw_data\habitat_quality"

mangrove_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\mangrove"
coral_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\coral_reef"
seagrass_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\seagrass"

moz_habitat_dir <- "G:\\Shared drives\\FF Portal\\GIS\\interactive_tool\\a_raw_data\\mozambique_habitat"

## 1b. setting output directories
compile_dir <-
intermediate_dir <-
zev_dir <- 

## 1c. load global data
country <- st_read(dsn = country_dir, layer = "level0") # GADM country boundary data at the national level
land_eez <- st_read(dsn = country_dir, layer = "EEZ_Land_v3_202030") # union of EEZ and land (will help for getting mangroves)
gmw <- st_read(dsn = mangrove_dir, layer = "GMW_2016_v2") # Global Mangrove Watch data

# habitat data
# Mozambique high resolution mangrove data
moz_fequete <- read_sf(dsn = moz_habitat_dir, layer = "moz_fequete_habitat_2019") # using read_sf --> is this faster? / why only 6 features?
moz_fequete <- st_read(dsn = moz_habitat_dir, layer = "moz_fequete_habitat_2019") # using st_read


moz_mocambique <- st_read(dsn = moz_habitat_dir, layer = "moz_ilha_de_mocambique_habitat_2020")
moz_machangulo <- st_read(dsn = moz_habitat_dir, layer = "moz_machangulo_habitat_2019")
moz_memba <- st_read(dsn = moz_habitat_dir, layer = "moz_memba_habitat_2019")
moz_pomene <- st_read(dsn = moz_habitat_dir, layer = "moz_pomene_habitat_2019")
moz_zavora <- st_read(dsn = moz_habitat_dir, layer = "moz_zavora_habitat_2019")

# Global Mangrove Watch country data
moz_mang <- st_read(dsn = mangrove_dir, layer = "moz_mang_2016")
phl_mang <- st_read(dsn = mangrove_dir, layer = "phl_mang_2016")

# Allen Coral Atlas data
ea_aca <- st_read(dsn = moz_habitat_dir, layer = "moz_aca")

######################################################
######################################################

### 2. Inspect the data

## 2a. finding which classes exist within the data
moz_fequete$Class_name <- as.factor(moz_fequete$Class_name)
levels(moz_fequete$Class_name)

moz_mocambique$Class_name <- as.factor(moz_mocambique$Class_name)
levels(moz_mocambique$Class_name)

moz_machangulo$Class_name <- as.factor(moz_machangulo$Class_name)
levels(moz_machangulo$Class_name)

moz_memba$Class_name <- as.factor(moz_memba$Class_name)
levels(moz_memba$Class_name)

moz_pomene$Class_name <- as.factor(moz_pomene$Class_name)
levels(moz_pomene$Class_name)

moz_zavora$Class_name <- as.factor(moz_zavora$Class_name)
levels(moz_zavora$Class_name)

## 2b. Inspect crs and set crs values if needed for later analyses
crs(country)
crs(land_eez)

crs(gmw)

crs(moz_fequete) # UTM Zone 36
crs(moz_mocambique) # UTM Zone 37 --> need to change to match the others
crs(moz_machangulo) # UTM Zone 36
crs(moz_memba) # UTM Zone 36
crs(moz_pomene) # UTM Zone 36
crs(moz_zavora) # UTM Zone 36

crs(ea_aca)

moz_mocambique_36s <- st_transform(moz_mocambique, crs = crs(moz_fequete))
crs(moz_mocambique_36s)
moz_mocambique_36s

## 2c. Sample Allen Coral Atlas data to inspect
ea_aca_sample <- sample_n(ea_aca, 100)

ea_aca_sample_seagrass <- ea_aca_sample %>%
  filter(class == "Seagrass")

head(ea_aca_sample_seagrass)

seagrass_sample_moz <- st_intersection(ea_aca_sample_seagrass,moz_land_eez)

######################################################
######################################################

### 3. Cleaning and preparing data

## 3.1 Mozambique high resolution habitat data
moz_fequete <- moz_fequete %>%
  dplyr::select(Class_name,
                PERIMETER,
                ENCLOSED_A,
                ISLAND_ARE,
                LENGTH,
                WIDTH)

moz_machangulo <- moz_machangulo %>%
  dplyr::select(Class_name,
                PERIMETER,
                ENCLOSED_A,
                ISLAND_ARE,
                LENGTH,
                WIDTH)

moz_memba <- moz_memba %>%
  dplyr::select(Class_name,
                PERIMETER,
                ENCLOSED_A,
                ISLAND_ARE,
                LENGTH,
                WIDTH)

moz_pomene <- moz_pomene %>%
  dplyr::select(Class_name,
                PERIMETER,
                ENCLOSED_A,
                ISLAND_ARE,
                LENGTH,
                WIDTH)

moz_zavora <- moz_zavora %>%
  dplyr::select(Class_name,
                PERIMETER,
                ENCLOSED_A,
                ISLAND_ARE,
                LENGTH,
                WIDTH)

moz_high_res_habitat <- rbind(moz_fequete,
                              moz_mocambique_36s,
                              moz_machangulo,
                              moz_memba,
                              moz_pomene,
                              moz_zavora)

moz_high_res_habitat_interest <- moz_high_res_habitat %>%
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
  dplyr::select(-PERIMETER,-ENCLOSED_A,-ISLAND_ARE,-LENGTH,-WIDTH)

# obtain necessary countries and boundaries
moz <- country %>%
  filter(NAME_0 == "Mozambique") %>% # Mozambique national boundary
  dplyr::mutate(iso3 = "MOZ") %>% # add new iso3 code field and populate with 
  dplyr::rename(country = NAME_0) %>% # change NAME_0 to country
  dplyr::select(country, iso3) # keep only the country and iso3 code fields

phl <- country %>%
  filter(NAME_0 == "Philippines") %>% # Philippines national boundary
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::rename(country = NAME_0) %>%
  dplyr::select(country, iso3)

moz_land_eez <- land_eez %>%
  filter(ISO_SOV1 == "MOZ") %>%
  dplyr::select(TERRITORY1,ISO_SOV1) %>%
  rename(country = TERRITORY1,
         iso3 = ISO_SOV1)

phl_land_eez <- land_eez %>%
  filter(ISO_SOV1 == "PHL") %>%
  dplyr::select(TERRITORY1,ISO_SOV1) %>%
  rename(country = TERRITORY1,
         iso3 = ISO_SOV1)

rare_countries <- rbind(moz,phl) # recombine the cleaned data for data of countries where Rare operates

# East Africa Allen Coral Atlas data for coral/algae and seagrass
ea_aca_seagrass <- moz_aca %>%
  filter(class == "Seagrass")
ea_aca_coral <- moz_aca %>%
  filter(class == "Coral/Algae")

# Mozambique Allen Coral Atlas data
moz_aca_seagrass <- st_intersection(ea_aca_seagrass,moz_land_eez)
moz_aca_coral <- st_intersection(ea_aca_coral,moz_land_eez)

moz_gmw_mangrove <- st_intersection(st_make_valid(gmw), moz_land_eez)

moz_gmw_mangrove <- moz_gmw_mangrove %>%
  dplyr::mutate(habitat = "mangrove") %>%
  dplyr::select(country, iso3, habitat, geometry)
moz_gmw_mangrove

# Philippines Global Mangrove Watch
phl_gmw_mangrove <- st_intersection(st_make_valid(gmw), phl_land_eez) %>%
  dplyr::mutate(habitat = "mangrove") %>%
  dplyr::select(country, iso3, habitat, geometry)
phl_gmw_mangrove
