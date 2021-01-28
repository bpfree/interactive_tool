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
pacman::p_load(berryFunctions,dplyr,raster,rgdal,sf,sp, stringr)

######################################################
######################################################

### 1. Setting up directories and loading the required data for analysis
### Set directories
## Input directory
clean_dir <- "data\\country\\phl\\b_clean_data"

## Output directories
tool_dir <- "data\\country\\phl\\d_tool_data"

######################################################
######################################################

### Habitat quality
## Load data
antique_hq <- st_read(dsn = clean_dir, "antique_habitat")
camotes_hq <- st_read(dsn = clean_dir, "camotes_habitat")
escalante_hq <- st_read(dsn = clean_dir, "escalante_city_habitat")
siargao_hq <- st_read(dsn = clean_dir, "siargao_habitat")


## Clean and prepare data
habitat_quality <- rbind(antique_hq,
                         camotes_hq,
                         escalante_hq,
                         siargao_hq) %>%
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::relocate(iso3, .after = ttl_crl)


## Export data for analysis or later integration in tool
st_write(habitat_quality, paste0(tool_dir, "/", "habitat_quality.shp"), append = F)




### Planning grid and habitat area
## Load planning unit data
antique_pu <- st_read(dsn = clean_dir, "antique_pu")
camotes_pu <- st_read(dsn = clean_dir, "camotes_pu")
escalante_pu <- st_read(dsn = clean_dir, "escalante_pu")
siargao_pu <- st_read(dsn = clean_dir, "siargao_pu")

## Load habitat area data
antique_habitat_area <- read.csv(paste(clean_dir, "antique_habitat_area.csv", sep= "/"), as.is = T)
camotes_habitat_area <- read.csv(paste(clean_dir, "camotes_habitat_area.csv", sep= "/"), as.is = T)
escalante_habitat_area <- read.csv(paste(clean_dir, "escalante_habitat_area.csv", sep= "/"), as.is = T)
siargao_habitat_area <- read.csv(paste(clean_dir, "siargao_habitat_area.csv", sep= "/"), as.is = T)

# Load mean habitat and Marxan data
#pu_mean <- read.csv(paste(clean_dir, "pu_mean.csv", sep = "/"), as.is = T)

## Clean and prepare data
# Function to link habitat with planning unit
pu_habitat_function <- function(data,data2){
  pu_habitat <- data %>%
    cbind(data2) %>%
    dplyr::select(-X, - region.1, -puid.1)
  
  return(pu_habitat)
}

# Run each area through the function
antique_pu_habitat <- pu_habitat_function(antique_pu,
                                          antique_habitat_area)
camotes_pu_habitat <- pu_habitat_function(camotes_pu,
                                          camotes_habitat_area)
escalante_pu_habitat <- pu_habitat_function(escalante_pu,
                                            escalante_habitat_area)
siargao_pu_habitat <- pu_habitat_function(siargao_pu,
                                          siargao_habitat_area)

# Combine the planning unit and habitat data
pu_habitat <- rbind(antique_pu_habitat,
                       camotes_pu_habitat,
                       escalante_pu_habitat,
                       siargao_pu_habitat)

# planning_grid <- merge(pu_habitat, pu_mean, by.x=c("region", "puid"), by.y=c("region", "puid")) %>%
#   dplyr::select(-X,-ISO3) %>%
#   dplyr::relocate(iso3,
#                   puid,
#                   region,
#                   reef_area_ha,
#                   seagrass_area_ha,
#                   mangrove_area_ha,
#                   total_area_ha,
#                   mean_coral_cover,
#                   mean_seagrass_cover,
#                   marxan_frequency)


## Export data for analysis or later integration
# st_write(planning_grid, dsn = paste0(tool_dir, "/", "planning_grid.shp"), append = F)

st_write(pu_habitat, dsn = paste0(tool_dir, "/", "planning_grid.shp"), append = F)
