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
tool_dir <- "data\\country\\phl\\d_tool_data"

## Output directories
geopackage <- "data\\country\\phl\\phl_interactive_tool.gpkg"

######################################################
######################################################

### 2. Loading layers for final preparation
country <- st_read(dsn = tool_dir, "country")
planning_grid <- st_read(dsn = tool_dir, "planning_grid")
managed_access_areas <- st_read(dsn = tool_dir, "managed_access_areas")
reef <- st_read(dsn = tool_dir, "reef")
mangrove <- st_read(dsn = tool_dir, "mangrove")
seagrass <- st_read(dsn = tool_dir, "seagrass")
habitat_quality <- st_read(dsn = tool_dir, "habitat_quality")
existing_reserves <- st_read(dsn = tool_dir, "existing_reserves")
connectivity_nodes_export <- st_read(dsn = tool_dir, "connectivity_nodes_export")
connectivity_nodes_import <- st_read(dsn = tool_dir, "connectivity_nodes_import")
larval_migration_export <- st_read(dsn = tool_dir, "larval_migration_export")
larval_migration_import <- st_read(dsn = tool_dir, "larval_migration_import")

reef <- st_make_valid(reef)
mangrove <- st_make_valid(mangrove)
seagrass <- st_make_valid(seagrass)

######################################################
######################################################

### 3. checking field names of data
colnames(country)
colnames(planning_grid)
colnames(managed_access_areas)
colnames(reef)
colnames(mangrove)
colnames(habitat_quality)
colnames(existing_reserves)
colnames(connectivity_nodes_export)
colnames(connectivity_nodes_import)
colnames(larval_migration_export)
colnames(larval_migration_import)

######################################################
######################################################

### 4. changing field names for geopackage
planning_grid <- planning_grid %>%
  dplyr::rename(mangrove_area_ha = mngrv__,
                reef_area_ha = ref_r_h,
                seagrass_area_ha = sgrss__,
                total_area_ha = ttl_r_h,
                mean_coral_cover = mn_crl_,
                mean_seagrass_cover = mn_sgr_,
                marxan_frequency = mrxn_fr)

habitat_quality <- habitat_quality %>%
  dplyr::rename(total_coral = ttl_crl)

existing_reserves <- existing_reserves %>%
  dplyr::rename(reserve_name = rsrv_nm)

######################################################
######################################################

### 5. Verifying field names of data
head(country)
head(planning_grid)
head(managed_access_areas)
head(reef)
head(mangrove)
head(habitat_quality)
head(existing_reserves)
head(connectivity_nodes_export)
head(connectivity_nodes_import)
head(larval_migration_export)
head(larval_migration_import)

######################################################
######################################################

### 6. Exporting to the Philippines geopackage
st_write(obj = country, dsn = geopackage, layer = "country", append = F)
st_write(obj = planning_grid, dsn = geopackage, layer = "planning_grid", append = F)
st_write(obj = managed_access_areas, dsn = geopackage, layer = "managed_access_areas", append = F)
st_write(obj = reef, dsn = geopackage, layer = "reef", append = F)
st_write(obj = mangrove, dsn = geopackage, layer = "mangrove", append = F)
st_write(obj = seagrass, dsn = geopackage, layer = "seagrass", append = F)
st_write(obj = habitat_quality, dsn = geopackage, layer = "habitat_quality", append = F)
st_write(obj = existing_reserves, dsn = geopackage, layer = "existing_reserves", append = F)
st_write(obj = connectivity_nodes_export, dsn = geopackage, layer = "connectivity_nodes_export", append = F)
st_write(obj = connectivity_nodes_import, dsn = geopackage, layer = "connectivity_nodes_import", append = F)
st_write(obj = larval_migration_export, dsn = geopackage, layer = "larval_migration_export", append = F)
st_write(obj = larval_migration_import, dsn = geopackage, layer = "larval_migration_import", append = F)
