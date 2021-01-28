#######################
# Rare Interactive Tool
#######################


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
### Set directories
## Country directories
phl_dir <- "data\\country\\phl\\phl_interactive_tool.gpkg"

## Output directories
tool_geopackage <- "data\\tool\\interactive_tool.gpkg"

######################################################
######################################################

### 2. Loading layers for each country
## Philippines (PHL)
phl_country <- st_read(dsn = phl_dir, "country")
phl_planning_grid <- st_read(dsn = phl_dir, "planning_grid")
phl_managed_access_areas <- st_read(dsn = phl_dir, "managed_access_areas")
phl_reef <- st_read(dsn = phl_dir, "reef")
phl_mangrove <- st_read(dsn = phl_dir, "mangrove")
phl_seagrass <- st_read(dsn = phl_dir, "seagrass")
phl_habitat_quality <- st_read(dsn = phl_dir, "habitat_quality")
phl_existing_reserves <- st_read(dsn = phl_dir, "existing_reserves")
phl_connectivity_nodes_export <- st_read(dsn = phl_dir, "connectivity_nodes_export")
phl_connectivity_nodes_import <- st_read(dsn = phl_dir, "connectivity_nodes_import")
phl_larval_migration_export <- st_read(dsn = phl_dir, "larval_migration_export")
phl_larval_migration_import <- st_read(dsn = phl_dir, "larval_migration_import")


######################################################
######################################################

### 3. Binding all country data
country <- rbind(phl_country)
planning_grid <- rbind(phl_planning_grid)
managed_access_areas <- rbind(phl_managed_access_areas)
reef <- rbind(phl_reef)
mangrove <- rbind(phl_mangrove)
seagrass <- rbind(phl_seagrass)
habitat_quality <- rbind(phl_habitat_quality)
existing_reserves <- rbind(phl_existing_reserves)
connectivity_nodes_export <- rbind(phl_connectivity_nodes_export)
connectivity_nodes_import <- rbind(phl_connectivity_nodes_import)
larval_migration_export <- rbind(phl_larval_migration_export)
larval_migration_import <- rbind(phl_larval_migration_import)

######################################################
######################################################

### 4. Exporting to the Philippines geopackage
st_write(obj = country, dsn = tool_geopackage, layer = "country", append = F)
st_write(obj = planning_grid, dsn = tool_geopackage, layer = "planning_grid", append = F)
st_write(obj = managed_access_areas, dsn = tool_geopackage, layer = "managed_access_areas", append = F)
st_write(obj = reef, dsn = tool_geopackage, layer = "reef", append = F)
st_write(obj = mangrove, dsn = tool_geopackage, layer = "mangrove", append = F)
st_write(obj = seagrass, dsn = tool_geopackage, layer = "seagrass", append = F)
st_write(obj = habitat_quality, dsn = tool_geopackage, layer = "habitat_quality", append = F)
st_write(obj = existing_reserves, dsn = tool_geopackage, layer = "existing_reserves", append = F)
st_write(obj = connectivity_nodes_export, dsn = tool_geopackage, layer = "connectivity_nodes_export", append = F)
st_write(obj = connectivity_nodes_import, dsn = tool_geopackage, layer = "connectivity_nodes_import", append = F)
st_write(obj = larval_migration_export, dsn = tool_geopackage, layer = "larval_migration_export", append = F)
st_write(obj = larval_migration_import, dsn = tool_geopackage, layer = "larval_migration_import", append = F)
