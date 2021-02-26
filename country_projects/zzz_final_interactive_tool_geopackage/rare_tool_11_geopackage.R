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
phl_dir <- "country_projects\\phl\\data\\phl_interactive_tool.gpkg"
moz_dir <- "country_projects\\moz\\data\\moz_interactive_tool.gpkg"

## Output directories
tool_geopackage <- "country_projects\\zzz_final_interactive_tool_geopackage\\interactive_tool.gpkg"

######################################################
######################################################

### 2. Loading layers for each country
## Mozambique (MOZ)
moz_country <- st_read(dsn = moz_dir, "country")
moz_planning_grid <- st_read(dsn = moz_dir, "planning_grid")
moz_managed_access_areas <- st_read(dsn = moz_dir, "managed_access_areas")
moz_reef <- st_read(dsn = moz_dir, "reef")
moz_mangrove <- st_read(dsn = moz_dir, "mangrove")
moz_seagrass <- st_read(dsn = moz_dir, "seagrass")
moz_habitat_quality <- st_read(dsn = moz_dir, "habitat_quality")
moz_habitat_quality_coral <- st_read(dsn = moz_dir, "habitat_quality_coral")
moz_habitat_quality_seagrass <- st_read(dsn = moz_dir, "habitat_quality_seagrass")
moz_existing_reserves <- st_read(dsn = moz_dir, "existing_reserves")
moz_connectivity_nodes_export <- st_read(dsn = moz_dir, "connectivity_nodes_export")
moz_connectivity_nodes_import <- st_read(dsn = moz_dir, "connectivity_nodes_import")
moz_larval_migration_export <- st_read(dsn = moz_dir, "larval_migration_export")
moz_larval_migration_import <- st_read(dsn = moz_dir, "larval_migration_import")

## Philippines (PHL)
phl_country <- st_read(dsn = phl_dir, "country")
phl_planning_grid <- st_read(dsn = phl_dir, "planning_grid")
phl_managed_access_areas <- st_read(dsn = phl_dir, "managed_access_areas")
phl_reef <- st_read(dsn = phl_dir, "reef")
phl_mangrove <- st_read(dsn = phl_dir, "mangrove")
phl_seagrass <- st_read(dsn = phl_dir, "seagrass")
phl_habitat_quality <- st_read(dsn = phl_dir, "habitat_quality")
phl_habitat_quality_coral <- st_read(dsn = phl_dir, "habitat_quality_coral")
phl_habitat_quality_seagrass <- st_read(dsn = phl_dir, "habitat_quality_seagrass")
phl_existing_reserves <- st_read(dsn = phl_dir, "existing_reserves")
phl_connectivity_nodes_export <- st_read(dsn = phl_dir, "connectivity_nodes_export")
phl_connectivity_nodes_import <- st_read(dsn = phl_dir, "connectivity_nodes_import")
phl_larval_migration_export <- st_read(dsn = phl_dir, "larval_migration_export")
phl_larval_migration_import <- st_read(dsn = phl_dir, "larval_migration_import")



######################################################
######################################################

### 3. Binding all country data
country <- rbind(moz_country,
                 phl_country)
planning_grid <- rbind(moz_planning_grid,
                       phl_planning_grid)
managed_access_areas <- rbind(moz_managed_access_areas,
                              phl_managed_access_areas)
reef <- rbind(moz_reef,
              phl_reef)
mangrove <- rbind(moz_mangrove,
                  phl_mangrove)
seagrass <- rbind(moz_seagrass,
                  phl_seagrass)
habitat_quality <- rbind(moz_habitat_quality,
                         phl_habitat_quality)
habitat_quality_coral <- rbind(phl_habitat_quality_coral)
habitat_quality_seagrass <- rbind(phl_habitat_quality_seagrass)
existing_reserves <- rbind(moz_existing_reserves,
                           phl_existing_reserves)
connectivity_nodes_export <- rbind(moz_connectivity_nodes_export,
                                   phl_connectivity_nodes_export)
connectivity_nodes_import <- rbind(moz_connectivity_nodes_import,
                                   phl_connectivity_nodes_import)
larval_migration_export <- rbind(moz_larval_migration_export,
                                 phl_larval_migration_export)
larval_migration_import <- rbind(moz_larval_migration_import,
                                 phl_larval_migration_import)

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
st_write(obj = habitat_quality_coral, dsn = tool_geopackage, layer = "habitat_quality_coral", append = F)
st_write(obj = habitat_quality_seagrass, dsn = tool_geopackage, layer = "habitat_quality_seagrass", append = F)
st_write(obj = existing_reserves, dsn = tool_geopackage, layer = "existing_reserves", append = F)
st_write(obj = connectivity_nodes_export, dsn = tool_geopackage, layer = "connectivity_nodes_export", append = F)
st_write(obj = connectivity_nodes_import, dsn = tool_geopackage, layer = "connectivity_nodes_import", append = F)
st_write(obj = larval_migration_export, dsn = tool_geopackage, layer = "larval_migration_export", append = F)
st_write(obj = larval_migration_import, dsn = tool_geopackage, layer = "larval_migration_import", append = F)
