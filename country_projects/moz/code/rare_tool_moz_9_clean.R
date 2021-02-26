#######################
# Rare Interactive Tool
#######################

#############
# Mozambique
#############

#####################
# Cleaning data
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
### Set directories
## Input directory
clean_dir <- "country_projects\\moz\\data\\b_clean_data"

## Output directories
analyze_dir <- "country_projects\\moz\\data\\c_analyze_data"
tool_dir <- "country_projects\\moz\\data\\d_tool_data"

### Set CRS
crs = 3395 # WGS84 World Mercator

######################################################
######################################################

### Coral
## Load data
moz_aca_coral <- st_read(dsn = clean_dir, layer = "moz_aca_coral")
moz_habitat_coral <- st_read(dsn = clean_dir, layer = "moz_habitat_coral")
moz_high_res_habitat_coral <- st_read(dsn = clean_dir, layer = "moz_high_res_habitat_coral")
moz_wcmc_coral <- st_read(dsn = clean_dir, layer = "moz_wcmc_coral")

## check details
colnames(moz_aca_coral)
colnames(moz_habitat_coral)
colnames(moz_high_res_habitat_coral)
colnames(moz_wcmc_coral)

crs(moz_aca_coral)
crs(moz_habitat_coral)
crs(moz_high_res_habitat_coral) # UTM 36S
crs(moz_wcmc_coral)

moz_aca_coral_wgs84 <- st_transform(moz_aca_coral, crs)
moz_habitat_coral_wgs84 <- st_transform(moz_habitat_coral, crs)
moz_high_res_habitat_coral_wgs84 <- st_transform(moz_high_res_habitat_coral, crs)
moz_wcmc_coral_wgs84 <- st_transform(moz_wcmc_coral, crs)

crs(moz_aca_coral_wgs84)
crs(moz_habitat_coral_wgs84)
crs(moz_high_res_habitat_coral_wgs84)
crs(moz_wcmc_coral_wgs84)

## combine data
moz_coral <- rbind(moz_aca_coral_wgs84,
                   moz_habitat_coral_wgs84,
                   moz_high_res_habitat_coral_wgs84,
                   moz_wcmc_coral_wgs84)

levels(as.factor(moz_coral$habitat)) # has Coral, Coral reef, Coral reefs --> need to mutate and rename habitat == "Coral reef"

moz_coral <- moz_coral %>%
  dplyr::mutate(habitat = "Coral reef")

levels(as.factor(moz_coral$habitat)) # check to verify that "Coral reef" is only habitat



### Mangrove
## Load data
moz_mangroves <- st_read(dsn = clean_dir, layer = "moz_mangroves")
moz_high_res_habitat_mangrove <- st_read(dsn = clean_dir, layer = "moz_high_res_habitat_mangrove")

## check details
colnames(moz_mangroves)
colnames(moz_high_res_habitat_mangrove)

crs(moz_mangroves)
crs(moz_high_res_habitat_mangrove)

moz_mangroves_wgs84 <- st_transform(moz_mangroves, crs)
moz_high_res_habitat_mangrove_wgs84 <- st_transform(moz_high_res_habitat_mangrove, crs)

crs(moz_mangroves_wgs84)
crs(moz_high_res_habitat_mangrove_wgs84)

moz_mangrove <- rbind(moz_mangroves_wgs84,
                      moz_high_res_habitat_mangrove_wgs84)

levels(as.factor(moz_mangrove$habitat)) # check to verify that "Mangrove" is the only habitat


### Seagrass
## Load data
moz_aca_seagrass <- st_read(dsn = clean_dir, layer = "moz_aca_seagrass")
moz_habitat_seagrass <- st_read(dsn = clean_dir, layer = "moz_habitat_seagrass")
moz_high_res_habitat_seagrass <- st_read(dsn = clean_dir, layer = "moz_high_res_habitat_seagrass")

## check details
colnames(moz_aca_seagrass)
colnames(moz_habitat_seagrass)
colnames(moz_high_res_habitat_seagrass)

crs(moz_aca_seagrass)
crs(moz_habitat_seagrass)
crs(moz_high_res_habitat_seagrass)

moz_aca_seagrass_wgs84 <- st_transform(moz_aca_seagrass, crs)
moz_habitat_seagrass_wgs84 <- st_transform(moz_habitat_seagrass, crs)
moz_high_res_habitat_seagrass_wgs84 <- st_transform(moz_high_res_habitat_seagrass, crs)

crs(moz_aca_seagrass_wgs84)
crs(moz_habitat_seagrass_wgs84)
crs(moz_high_res_habitat_seagrass_wgs84)

moz_seagrass <- rbind(moz_aca_seagrass_wgs84,
                      moz_habitat_seagrass_wgs84,
                      moz_high_res_habitat_seagrass_wgs84)

levels(as.factor(moz_seagrass$habitat)) # check to verify that "Mangrove" is the only habitat



### Functions to reduce features
## Clean functions (coral, mangrove, seagrass)
coral_clean_function <- function(data){
  moz_coral_data <- data %>%
    dplyr::mutate(area = st_area(data)) %>%
    summarise(area = sum(area)) %>%
    dplyr::mutate(iso3 = "MOZ",
          habitat = "Coral reef") %>%
    dplyr::select(iso3, habitat)
  return(moz_coral_data)
}

mangrove_clean_function <- function(data){
  moz_mangrove_data <- data %>%
    dplyr::mutate(area = st_area(data)) %>%
    summarise(area = sum(area)) %>%
    dplyr::mutate(iso3 = "MOZ",
                  habitat = "Mangrove") %>%
    dplyr::select(iso3, habitat)
  return(moz_mangrove_data)
}

seagrass_clean_function <- function(data){
  moz_seagrass_data <- data %>%
    dplyr::mutate(area = st_area(data)) %>%
    summarise(area = sum(area)) %>%
    dplyr::mutate(iso3 = "MOZ",
                  habitat = "Seagrass") %>%
    dplyr::select(iso3, habitat)
  return(moz_seagrass_data)
}

## Reducing to single feature to remove overlapping features
moz_coral_reef <- coral_clean_function(moz_coral)


## Export data for analysis (reconciling any areas that )















### Seagrass habitat quality
## Load seagrass data
habitat_quality_seagrass <- st_read(dsn = clean_dir, "habitat_quality_seagrass")
View(habitat_quality_seagrass)

## Export data for tool
st_write(obj = habitat_quality_seagrass, dsn = paste0(tool_dir, "/", "habitat_quality_seagrass.shp"), append = F)





### Planning grid and habitat area
## Load planning unit data
phl_pu <- st_read(dsn = clean_dir, "phl_pu")

## Load habitat area data
antique_habitat_area <- read.csv(paste(clean_dir, "antique_habitat_area.csv", sep= "/"), as.is = T)
cebu_habitat_area <- read.csv(paste(clean_dir, "cebu_habitat_area.csv", sep= "/"), as.is = T)
negros_occidental_habitat_area <- read.csv(paste(clean_dir, "negros_occidental_habitat_area.csv", sep= "/"), as.is = T)
surigao_del_norte_habitat_area <- read.csv(paste(clean_dir, "surigao_del_norte_habitat_area.csv", sep= "/"), as.is = T)

phl_habitat <- rbind(antique_habitat_area,
                     cebu_habitat_area,
                     negros_occidental_habitat_area,
                     surigao_del_norte_habitat_area)

# Load mean habitat and Marxan data
pu_mean <- read.csv(paste(clean_dir, "pu_mean.csv", sep = "/"), as.is = T)
pu_mean <- pu_mean %>%
  dplyr::mutate(region = recode(region, "antique" = "Antique",
                                        "camotes" = "Cebu",
                                        "escalante" = "Negros Occidental",
                                        "siargao" = "Surigao del Norte"))

View(pu_mean)
x <- as.factor(pu_mean$region)
levels(x)

## Clean and prepare data
# Function to link habitat with planning unit
pu_habitat_function <- function(data,data2){
  pu_habitat <- data %>%
    cbind(data2) %>%
    dplyr::select(-X, - region.1, -puid.1)
  
  return(pu_habitat)
}

phl_habitat_clean <- pu_habitat_function(phl_pu,
                                         phl_habitat)

planning_grid <- merge(phl_habitat_clean, pu_mean, by.x=c("region", "puid"), by.y=c("region", "puid")) %>%
  dplyr::select(-X,-ISO3) %>%
  dplyr::relocate(iso3,
                  puid,
                  region,
                  reef_area_ha,
                  seagrass_area_ha,
                  mangrove_area_ha,
                  total_area_ha,
                  mean_coral_cover,
                  mean_seagrass_cover,
                  marxan_frequency)

View(planning_grid)


## Export data for analysis or later integration
st_write(planning_grid, dsn = paste0(analyze_dir, "/", "planning_grid.shp"), append = F)
