#######################
# Rare Interactive Tool
#######################

#############
# Mozambique
#############

#####################
# Analyzing data
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
analyze_dir <- "country_projects\\moz\\data\\c_analyze_data"

## Output directories
tool_dir <- "country_projects\\moz\\data\\d_tool_data"


######################################################
######################################################

### 2. Larval connectivity
## Loading larval connectivity data
crb_connectivity_import <- st_read(dsn = analyze_dir, "crb_import")
crb_connectivity_export <- st_read(dsn = analyze_dir, "crb_export")

emp_connectivity_import <- st_read(dsn = analyze_dir, "emp_import")
emp_connectivity_export <- st_read(dsn = analyze_dir, "emp_export")

fus_connectivity_import <- st_read(dsn = analyze_dir, "fus_import")
fus_connectivity_export <- st_read(dsn = analyze_dir, "fus_export")

grp_connectivity_import <- st_read(dsn = analyze_dir, "grp_import")
grp_connectivity_export <- st_read(dsn = analyze_dir, "grp_export")

pfs_connectivity_import <- st_read(dsn = analyze_dir, "pfs_import")
pfs_connectivity_export <- st_read(dsn = analyze_dir, "pfs_export")


## Functions that generate and bind the quantile classifications of import / export values
# import functions
import_quantile_function <- function(data){
  
  import_data_quantiled <- data %>%
    classify(data,
             method = "quantile",
             breaks = 5)
  
  return(import_data_quantiled)
}

import_classify_function <- function(data,data2){
  
  import_data_classified <- data %>%
    cbind(data2$index) %>%
    dplyr::rename(quantile = data2.index) %>%
    dplyr::select(import, quantile, species, iso3)
  
  return(import_data_classified)
}

## export functions
export_quantile_function <- function(data){
  
  export_data_quantiled <- data %>%
    classify(data,
             method = "quantile",
             breaks = 5)
  
  return(export_data_quantiled)
}

export_classify_function <- function(data,data2){
  
  export_data_classified <- data %>%
    cbind(data2$index) %>%
    dplyr::rename(quantile = data2.index) %>%
    dplyr::select(export, quantile, species, iso3)
  
  return(export_data_classified)
}

# Larval import connectivity by species
crb_import_quantile <- import_quantile_function(crb_connectivity_import$import)
crb_import_classify <- import_classify_function(crb_connectivity_import,crb_import_quantile)

emp_import_quantile <- import_quantile_function(emp_connectivity_import$import)
emp_import_classify <- import_classify_function(emp_connectivity_import,emp_import_quantile)

fus_import_quantile <- import_quantile_function(fus_connectivity_import$import)
fus_import_classify <- import_classify_function(fus_connectivity_import,fus_import_quantile)

grp_import_quantile <- import_quantile_function(grp_connectivity_import$import)
grp_import_classify <- import_classify_function(grp_connectivity_import,grp_import_quantile)

pfs_import_quantile <- import_quantile_function(pfs_connectivity_import$import)
pfs_import_classify <- import_classify_function(pfs_connectivity_import,pfs_import_quantile)

larval_connectivity_import <- rbind(crb_import_classify,
                                    emp_import_classify,
                                    fus_import_classify,
                                    grp_import_classify,
                                    pfs_import_classify)

# Larval export connectivity by species
crb_export_quantile <- export_quantile_function(crb_connectivity_export$export)
crb_export_classify <- export_classify_function(crb_connectivity_export,crb_export_quantile)

emp_export_quantile <- export_quantile_function(emp_connectivity_export$export)
emp_export_classify <- export_classify_function(emp_connectivity_export,emp_export_quantile)

fus_export_quantile <- export_quantile_function(fus_connectivity_export$export)
fus_export_classify <- export_classify_function(fus_connectivity_export,fus_export_quantile)

grp_export_quantile <- export_quantile_function(grp_connectivity_export$export)
grp_export_classify <- export_classify_function(grp_connectivity_export,grp_export_quantile)

pfs_export_quantile <- export_quantile_function(pfs_connectivity_export$export)
pfs_export_classify <- export_classify_function(pfs_connectivity_export,pfs_export_quantile)

larval_connectivity_export <- rbind(crb_export_classify,
                                    emp_export_classify,
                                    fus_export_classify,
                                    grp_export_classify,
                                    pfs_export_classify)

######################################################
######################################################

### 3. Larval migration
## Loading larval migration data
crb_migration_import <- st_read(dsn = analyze_dir, "crb_migration_import")
crb_migration_export <- st_read(dsn = analyze_dir, "crb_migration_export")

emp_migration_import <- st_read(dsn = analyze_dir, "emp_migration_import")
emp_migration_export <- st_read(dsn = analyze_dir, "emp_migration_export")

fus_migration_import <- st_read(dsn = analyze_dir, "fus_migration_import")
fus_migration_export <- st_read(dsn = analyze_dir, "fus_migration_export")

grp_migration_import <- st_read(dsn = analyze_dir, "grp_migration_import")
grp_migration_export <- st_read(dsn = analyze_dir, "grp_migration_export")

pfs_migration_import <- st_read(dsn = analyze_dir, "pfs_migration_import")
pfs_migration_export <- st_read(dsn = analyze_dir, "pfs_migration_export")


## Functions that generate and bind the quantile classifications of import / export values
# import functions
import_quantile_migration <- function(data){
  
  import_migration_quantiled <- data %>%
    classify(data,
             method = "quantile",
             breaks = 5)
  
  return(import_migration_quantiled)
}

import_classify_migration <- function(data,data2){
  
  import_migration_classified <- data %>%
    cbind(data2$index) %>%
    dplyr::rename(quantile = data2.index) %>%
    dplyr::select(migration, import, quantile, species, iso3)
  
  return(import_migration_classified)
}

## export functions
export_quantile_migration <- function(data){
  
  export_migration_quantiled <- data %>%
    classify(data,
             method = "quantile",
             breaks = 5)
  
  return(export_migration_quantiled)
}

export_classify_migration <- function(data,data2){
  
  export_migration_classified <- data %>%
    cbind(data2$index) %>%
    dplyr::rename(quantile = data2.index) %>%
    dplyr::select(migration, export, quantile, species, iso3)
  
  return(export_migration_classified)
}

# Larval import migration by species
crb_migration_import_quantile <- import_quantile_migration(crb_migration_import$migration)
crb_migration_import_classify <- import_classify_migration(crb_migration_import,crb_migration_import_quantile)

emp_migration_import_quantile <- import_quantile_migration(emp_migration_import$migration)
emp_migration_import_classify <- import_classify_migration(emp_migration_import,emp_migration_import_quantile)

fus_migration_import_quantile <- import_quantile_migration(fus_migration_import$migration)
fus_migration_import_classify <- import_classify_migration(fus_migration_import,fus_migration_import_quantile)

grp_migration_import_quantile <- import_quantile_migration(grp_migration_import$migration)
grp_migration_import_classify <- import_classify_migration(grp_migration_import,grp_migration_import_quantile)

pfs_migration_import_quantile <- import_quantile_migration(pfs_migration_import$migration)
pfs_migration_import_classify <- import_classify_migration(pfs_migration_import,pfs_migration_import_quantile)

larval_migration_import <- rbind(crb_migration_import_classify,
                                 emp_migration_import_classify,
                                 fus_migration_import_classify,
                                 grp_migration_import_classify,
                                 pfs_migration_import_classify)

# Larval export migration by species
crb_migration_export_quantile <- export_quantile_migration(crb_migration_export$migration)
crb_migration_export_classify <- export_classify_migration(crb_migration_export,crb_migration_export_quantile)

emp_migration_export_quantile <- export_quantile_migration(emp_migration_export$migration)
emp_migration_export_classify <- export_classify_migration(emp_migration_export,emp_migration_export_quantile)

fus_migration_export_quantile <- export_quantile_migration(fus_migration_export$migration)
fus_migration_export_classify <- export_classify_migration(fus_migration_export,fus_migration_export_quantile)

grp_migration_export_quantile <- export_quantile_migration(grp_migration_export$migration)
grp_migration_export_classify <- export_classify_migration(grp_migration_export,grp_migration_export_quantile)

pfs_migration_export_quantile <- export_quantile_migration(pfs_migration_export$migration)
pfs_migration_export_classify <- export_classify_migration(pfs_migration_export,pfs_migration_export_quantile)


larval_migration_export <- rbind(crb_migration_export_classify,
                                 emp_migration_export_classify,
                                 fus_migration_export_classify,
                                 grp_migration_export_classify,
                                 pfs_migration_export_classify)

######################################################
######################################################

### 4. Habitat area extents

## load data
mangrove <- st_read(dsn = analyze_dir, "mangrove")
coral <- st_read(dsn = analyze_dir, "reef")
seagrass <- st_read(dsn = analyze_dir, "seagrass")

coral_participatory <- st_read(dsn = analyze_dir, "coral_participatory")
mangrove_participatory <- st_read(dsn = analyze_dir, "mangrove_participatory")


## combining habitat area
coral_reef_combine <- rbind(coral,
                            coral_participatory)
coral_reef_simplified <- coral_reef_combine %>%
  dplyr::mutate(area = st_area(coral_reef_combine)) %>%
  summarise(area = sum(area)) %>%
  dplyr::mutate(iso3 = "MOZ",
                habitat = "Coral reef") %>%
  dplyr::select(iso3, habitat)


mangrove_combine <- rbind(mangrove,
                          mangrove_participatory) 
mangrove_simplified <- mangrove_combine %>%
  dplyr::mutate(area = st_area(mangrove_combine)) %>%
  summarise(area = sum(area)) %>%
  dplyr::mutate(iso3 = "MOZ",
                habitat = "Mangrove") %>%
  dplyr::select(iso3, habitat)
View(mangrove_simplified)

seagrass_simplified <- seagrass %>%
  dplyr::mutate(area = st_area(seagrass)) %>%
  summarise(area = sum(area)) %>%
  dplyr::mutate(iso3 = "MOZ",
                habitat = "Seagrass") %>%
  dplyr::select(iso3, habitat)
View(seagrass_simplified)

coral_minus_mangroves <- st_difference(st_make_valid(coral_reef_simplified),
                                       st_make_valid(mangrove_simplified))



# reef <- st_difference(st_make_valid(coral_minus_mangroves), # process takes a long time
#                       st_make_valid(seagrass_simplified))
# 
# reef <- reef %>%
#   dplyr::select(iso3,habitat)
# 
# mangrove_tool <- st_make_valid(mangrove_simplified)
# coral_reef <- st_make_valid(reef) # process takes a long time
# seagrass_tool <- st_make_valid(seagrass_simplified)


######################################################
######################################################
### 5. Planning grid managed access area percentages

## load the data
# Marxan frequency data across all interested managed access areas
moz <- read.csv(paste(analyze_dir, "phl_marxan.csv", sep= "/"), as.is = T)
View(moz_maa_marxan)

# original planning grid data
planning_units <- st_read(dsn = analyze_dir, "planning_grid")
View(planning_units)

# key for planning unit ID and managed access area names
maa_names <- read.csv(paste(analyze_dir, "planning_grid_ma_region.csv", sep= "/"), as.is = T)
View(maa_names)

levels(as.factor(maa_names$maa))

# See how each managed access area matches with the region of interest
grouping <- maa_names %>%
  group_by(maa) %>%
  summarise(region = first(region))

## combine the data based on puid, region, and maa names
# first need to combine the original planning grid data (which has puid and region data but not maa nor areas) with table that has puid, region, and maa names
pu_maa_names <- merge(planning_units, maa_names, by.x = c("region", "puid"), by.y = c("region", "puid"))
View(pu_maa_names) # sf now has maa name

pu_marxan <- merge(pu_maa_names, phl_maa_marxan, by.x = c("region", "puid"), by.y = c("region", "puid")) %>%
  dplyr::rename(maa = maa.x) %>%
  dplyr::select(-X, -maa.y)

# summed habitat area per managed access area data
maa_habitat <- pu_marxan %>%
  group_by(maa,region) %>%
  summarise(coral_maa = sum(ref_r_h),
            mangrove_maa = sum(mngrv__),
            seagrass_maa = sum(sgrss__),
            total_maa = sum(ttl_r_h))
View(maa_habitat)

st_geometry(maa_habitat) <- NULL # need to make data frame for allowing to be joined in a later step
class(maa_habitat)

# now can join original managed access data with has area values with the planning grid data using the maa names
pu_ma_area <- left_join(pu_maa_names,maa_habitat) %>%
  dplyr::rename(coral_puid_ha = ref_r_h,
                mangrove_puid_ha = mngrv__,
                seagrass_puid_ha = sgrss__,
                total_puid_ha = ttl_r_h,
                mean_coral_cover = mn_crl_,
                mean_seagrass_cover = mn_sgr_) %>%
  dplyr::mutate(coral_maa_pct = (coral_puid_ha / coral_maa) * 100,
                mangrove_maa_pct = (mangrove_puid_ha / mangrove_maa) * 100,
                seagrass_maa_pct = (seagrass_puid_ha / seagrass_maa) * 100,
                total_maa_pct = (total_puid_ha / total_maa) * 100) %>%
  dplyr::select(iso3, puid, region, maa, coral_maa, mangrove_maa, seagrass_maa, total_maa,
                coral_puid_ha, mangrove_puid_ha, seagrass_puid_ha, total_puid_ha,
                coral_maa_pct, mangrove_maa_pct, seagrass_maa_pct, total_maa_pct,
                mean_coral_cover, mean_seagrass_cover, marxan_frequency)
View(pu_ma_area)



######################################################
######################################################


### 6. Export data for tool integration
st_write(obj = larval_connectivity_import, dsn = paste0(tool_dir, "/", "connectivity_nodes_import.shp"), append = F)
st_write(obj = larval_connectivity_export, dsn = paste0(tool_dir, "/", "connectivity_nodes_export.shp"), append = F)

st_write(obj = larval_migration_import, dsn = paste0(tool_dir, "/", "larval_migration_import.shp"), append = F)
st_write(obj = larval_migration_export, dsn = paste0(tool_dir, "/", "larval_migration_export.shp"), append = F)

st_write(obj = coral_reef, dsn = paste0(tool_dir, "/", "reef.shp"), append = F)
st_write(obj = mangrove_tool, dsn = paste0(tool_dir, "/", "mangrove.shp"), append = F)
st_write(obj = seagrass_tool, dsn = paste0(tool_dir, "/", "seagrass.shp"), append = F)

st_write(obj = reef, dsn = paste0(tool_dir, "/", "reef1.shp"), append = F)
st_write(obj = coral_reef_simplified, dsn = paste0(tool_dir, "/", "reef_simplified.shp"), append = F)
st_write(obj = coral_minus_mangroves, dsn = paste0(tool_dir, "/", "coral_minus_mangrove.shp"), append = F)

st_write(obj = pu_ma_area, dsn = paste0(tool_dir, "/", "planning_grid.shp"), append = F)
