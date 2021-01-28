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
pacman::p_load(berryFunctions,dplyr,raster,rgdal,sf,sp)

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
country_dir <- "a_raw_data\\country\\gadm36_levels.gpkg"
eez_dir <- "a_raw_data\\country"
managed_access_dir <- "a_raw_data\\managed_access_areas"
pu_dir <- "a_raw_data\\planning_grid"
reserve_dir <- "a_raw_data\\existing_reserve"
habitat_quality_dir <- "a_raw_data\\habitat_quality"
habitat_area_dir <- "a_raw_data\\habitat_area"

mangrove_dir <- "a_raw_data\\mangrove"
coral_dir <- "a_raw_data\\coral_reef"
seagrass_dir <- "a_raw_data\\seagrass"

larval_dir <- "a_raw_data\\larval_connectivity"

## 1b. setting output directories
#compile_dir <-
#intermediate_dir <-
zev_dir <- "d_final_data\\phl_interactive_tool.gpkg"


## 1c. inspect the directories
list.files(country_dir)
list.files(eez_dir)
list.files(managed_access_dir)
list.files(pu_dir)
list.files(reserve_dir)
list.files(habitat_quality_dir)
list.files(habitat_area_dir)

list.files(mangrove_dir)
list.files(coral_dir)
list.files(seagrass_dir)

list.files(larval_dir)

######################################################
######################################################

### 2. load the data
  
## 2a. load administrative boundary data
country <- st_read(dsn = country_dir, layer = "level0") # GADM country boundary data at the national level
land_eez <- st_read(dsn = eez_dir, layer = "EEZ_Land_v3_202030") # union of EEZ and land (will help for getting mangroves)

## 2b. load planning, managed access, and reserve data
phl_ma <- st_read(dsn = managed_access_dir, layer = "phl_proposed_ma")
phl_reserves <- st_read(dsn = reserve_dir, layer = "phl_reserves_established")
phl_antique_pu <- st_read(dsn = pu_dir, layer = "antique_pu")
phl_camotes_pu <- st_read(dsn = pu_dir, layer = "camotes_pu")
phl_escalante_pu <- st_read(dsn = pu_dir, layer = "escalante_pu")
phl_siargao_pu <- st_read(dsn = pu_dir, layer = "siargao_pu")

## 2c. habitat data -- Philippines mangrove data (phl_mang <- st_read(dsn = mangrove_dir, layer = "phl_mang_2016"))
mangrove_gmw <- st_read(dsn = mangrove_dir, layer = "GMW_2016_v2") # Global Mangrove Watch mangrove data
coral_wcmc <- st_read(dsn = coral_dir, layer = "coral_reef_wcmc") # UNEP-WCMC coral reef data
phl_antique <- st_read(dsn = habitat_quality_dir, layer = "phl_antique_mantatow")
phl_camotes <- st_read(dsn = habitat_quality_dir, layer = "phl_camotes_mantatow")
phl_escalantecity <- st_read(dsn = habitat_quality_dir, layer = "phl_escalantecity_mantatow")
phl_siargao <- st_read(dsn = habitat_quality_dir, layer = "phl_siargao_mantatow")

## 2d. habitat quality data -- raster formats
# Inverse distance weighted rasters of coral and seagrass habitats
# phl_antique_cr_hq <- raster(file.path(habitat_quality_dir,"antique_reef.tif"))
# phl_camotes_cr_hq <- raster(file.path(habitat_quality_dir,"camotes_reef.tif"))
# phl_escalante_cr_hq <- raster(file.path(habitat_quality_dir,"escalan_reef.tif"))
# phl_siargao_cr_hq <- raster(file.path(habitat_quality_dir,"siargao_reef.tif"))
# phl_siargao_sg_hq <- raster(file.path(habitat_quality_dir,"siargao_sg.tif"))

## 2e. habitat area
phl_antique_habitat_area <- read.csv(paste(habitat_area_dir, "antique_habitat_area.csv", sep="/"), as.is = T)
phl_camotes_habitat_area <- read.csv(paste(habitat_area_dir, "camotes_habitat_area.csv", sep="/"), as.is = T)
phl_escalante_habitat_area <- read.csv(paste(habitat_area_dir, "escalante_habitat_area.csv", sep="/"), as.is = T)
phl_siargao_habitat_area <- read.csv(paste(habitat_area_dir, "siargao_habitat_area.csv", sep="/"), as.is = T)

## 2f. larval connectivity data
# Acanthurus lineatus
aline_import <- st_read(dsn = larval_dir, layer = "aline_import")
aline_export <- st_read(dsn = larval_dir, layer = "aline_export")

# Caesio caerulauren
ccaer_import <- st_read(dsn = larval_dir, layer = "ccaer_import")
ccaer_export <- st_read(dsn = larval_dir, layer = "ccaer_export")

# Chlorurus bleekeri
cblee_import <- st_read(dsn = larval_dir, layer = "cblee_import")
cblee_export <- st_read(dsn = larval_dir, layer = "cblee_export")

# Lutjanus ehrenbergii
lehre_import <- st_read(dsn = larval_dir, layer = "lehre_import")
lehre_export <- st_read(dsn = larval_dir, layer = "lehre_export")

# Naso mino
nmino_import <- st_read(dsn = larval_dir, layer = "nmino_import")
nmino_export <- st_read(dsn = larval_dir, layer = "nmino_export")

# Parupeneus multifasciatus
pmult_import <- st_read(dsn = larval_dir, layer = "pmult_import")
pmult_export <- st_read(dsn = larval_dir, layer = "pmult_export")

# Plectropomus leopardus
pleop_import <- st_read(dsn = larval_dir, layer = "pleop_import")
pleop_export <- st_read(dsn = larval_dir, layer = "pleop_export")

# Pterocaesio pisang
ppisa_import <- st_read(dsn = larval_dir, layer = "ppisa_import")
ppisa_export <- st_read(dsn = larval_dir, layer = "ppisa_export")

# Scarus globiceps
sglob_import <- st_read(dsn = larval_dir, layer = "sglob_import")
sglob_export <- st_read(dsn = larval_dir, layer = "sglob_export")

# Siganus canaliculatus
scana_import <- st_read(dsn = larval_dir, layer = "scana_import")
scana_export <- st_read(dsn = larval_dir, layer = "scana_export")


######################################################
######################################################

### 3. Inspect the data (classes, crs, etc.)

## 3a. Examine the top of the data
head(country)
head(land_eez)

head(phl_ma)
head(phl_reserves)

head(phl_antique)
head(phl_camotes)
head(phl_escalantecity)
head(phl_siargao)

head(mangrove_gmw)
head(coral_wcmc)


## 3b. Inspect crs and set crs values if needed for later analyses
crs(country)
crs(land_eez)

crs(phl_ma)
crs(phl_reserves) # UTM Zone 51

crs(phl_antique)
crs(phl_camotes)
crs(phl_escalantecity)
crs(phl_siargao)

crs(mangrove_gmw)
crs(coral_wcmc)



######################################################
######################################################

### 4. Cleaning and preparing data

## 4a. Philippines habitat quality data

phl_antique_clean <- phl_antique %>%
  dplyr::mutate(LC = as.numeric(LC)) %>%
  dplyr::mutate(total_coral = LC) %>%
  dplyr::select(total_coral)

phl_camotes_clean <- phl_camotes %>%
  dplyr::mutate(Live_coral = as.numeric(Live_coral)) %>%
  dplyr::mutate(Soft_coral = as.numeric(Soft_coral)) %>%
  dplyr::mutate(total_coral = Live_coral+Soft_coral) %>%
  dplyr::select(total_coral)

phl_escalantecity_clean <- phl_escalantecity %>%
  dplyr::mutate(LHC = as.numeric(LHC)) %>%
  dplyr::mutate(SC = as.numeric(SC)) %>%
  dplyr::mutate(total_coral = LHC + SC) %>%
  dplyr::select(total_coral)

phl_siargao_clean <- phl_siargao %>%
  dplyr::mutate(total_coral = Hard_coral + Soft_coral)

phl_seagrass_quality <- phl_siargao_clean %>%
  dplyr::rename(seagrass = Other) %>%
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::select(seagrass, iso3)

phl_siargao_coral <- phl_siargao_clean %>%
  dplyr::select(total_coral)

phl_coral_quality <- rbind(phl_antique_clean,
                    phl_camotes_clean,
                    phl_escalantecity_clean,
                    phl_siargao_coral) %>%
  mutate(iso3 = "PHL") %>%
  relocate(iso3, .after = total_coral)
  

View(phl_coral_quality)
View(phl_seagrass_quality)


# 4b. obtain necessary countries and boundaries
phl <- country %>%
  dplyr::filter(NAME_0 == "Philippines") %>% # Philippines national boundary
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::rename(country = NAME_0) %>%
  dplyr::select(country, iso3)

phl_land_eez <- land_eez %>%
  dplyr::filter(ISO_SOV1 == "PHL") %>%
  dplyr::select(TERRITORY1,ISO_SOV1) %>%
  dplyr::rename(country = TERRITORY1,
         iso3 = ISO_SOV1)

# 4c. combine the planning units

planning_unit_clean <- function(data){
  pu_clean <- data %>%
    dplyr::mutate(pu = "camotes") %>% ## update pu name before running Camotes, Escalante City, Siargao
    dplyr::mutate(iso3 = "PHL") %>%
    dplyr::rename(puid = PUID) %>%
    dplyr::select(puid,pu,iso3)
  return(pu_clean)
}

# Antique planning units
phl_antique_pu_clean <- phl_antique_pu %>%
  dplyr::mutate(pu = "antique") %>%
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::rename(puid = PUID) %>%
  dplyr::select(-FID_1)

# Camotes planning units
phl_camotes_pu_clean <- planning_unit_clean(phl_camotes_pu)

# Escalante planning units
phl_escalante_pu_clean <- planning_unit_clean(phl_escalante_pu)

# Siargao planning units
phl_siargao_pu_clean <- planning_unit_clean(phl_siargao_pu)

# combined all planning units
phl_pu <- rbind(phl_antique_pu_clean,
                  phl_camotes_pu_clean,
                  phl_escalante_pu_clean,
                  phl_siargao_pu_clean)

# 4d. Habitat areas combined with planning units
habitat_clean_function <- function(data){
  
  habitat_area_clean <- data %>%
    dplyr::mutate(mangrove_area_ha = 100 * as.numeric(Mangrove_Area),
                  reef_area_ha = 100 * as.numeric(Reef_Area),
                  seagrass_area_ha = 100 * as.numeric(Seagrass_Area),
                  total_area_ha = mangrove_area_ha + reef_area_ha + seagrass_area_ha) %>%
    dplyr::select(PUID, mangrove_area_ha, reef_area_ha, seagrass_area_ha, total_area_ha)
  
  return(habitat_area_clean)
}

pu_habitat_clean_function <- function(data,data2){
  pu_habitat <- data %>%
    cbind(data2) %>%
    dplyr::select(-PUID)
  
  return(pu_habitat)
}


# Antique habitat
phl_antique_habitat_area_clean <- habitat_clean_function(phl_antique_habitat_area)
phl_antique_pu_habitat_area <- pu_habitat_clean_function(phl_antique_pu_clean,
                                                         phl_antique_habitat_area_clean)


# Camotes habitat
phl_camotes_habitat_area_clean <- habitat_clean_function(phl_camotes_habitat_area)
phl_camotes_pu_habitat_area <- pu_habitat_clean_function(phl_camotes_pu_clean,
                                                         phl_camotes_habitat_area_clean)

# Escalante habitat
phl_escalante_habitat_area_clean <- habitat_clean_function(phl_escalante_habitat_area)
phl_escalante_pu_habitat_area <- pu_habitat_clean_function(phl_escalante_pu_clean,
                                                         phl_escalante_habitat_area_clean)

# Siargo habitat
phl_siargao_habitat_area_clean <- habitat_clean_function(phl_siargao_habitat_area)
phl_siargao_pu_habitat_area <- pu_habitat_clean_function(phl_siargao_pu_clean,
                                                         phl_siargao_habitat_area_clean)

# Combined habitat areas and planning units
phl_pu_habitat_area <- rbind(phl_antique_pu_habitat_area,
                             phl_camotes_pu_habitat_area,
                             phl_escalante_pu_habitat_area,
                             phl_siargao_pu_habitat_area) %>%
  dplyr::relocate(puid, .after = pu)
  

######################################################
######################################################

### 5. Subsetting data to the EEZ and area of interest

## 5a. Mangroves found in the Philippines
phl_mangroves <- st_intersection(st_make_valid(mangrove_gmw), phl_land_eez) %>%
  dplyr::mutate(habitat = "mangrove") %>%
  dplyr::select(country, iso3, habitat)
head(phl_mangroves)

phl_coral <- st_intersection(coral_wcmc, phl_land_eez) %>%
  dplyr::mutate(habitat = "coral", iso3 = "PHL") %>%
  dplyr::select(habitat, iso3)
head(phl_coral)

######################################################
######################################################

### 6. Working with the larval connectivity

## 6a. Import data

import_clean_function <- function(data){
  
  import_data_cleaned <- data %>%
    dplyr::select(wInDeg) %>%
    dplyr::rename(import = wInDeg) %>%
    dplyr::mutate(iso3 = "PHL") %>%
    dplyr::relocate(iso3, .after = import)
  
  return(import_data_cleaned)
}

aline_import_clean <- import_clean_function(aline_import) %>%
  dplyr::mutate(species = "Acanthurus lineatus") %>%
  dplyr::relocate(species, .after = import)
ccaer_import_clean <- import_clean_function(ccaer_import) %>%
  dplyr::mutate(species = "Caesio caerulaurea") %>%
  dplyr::relocate(species, .after = import)
cblee_import_clean <- import_clean_function(cblee_import) %>%
  dplyr::mutate(species = "Chlorurus bleekeri") %>%
  dplyr::relocate(species, .after = import)
lehre_import_clean <- import_clean_function(lehre_import) %>%
  dplyr::mutate(species = "Lutjanus ehrenbergii") %>%
  dplyr::relocate(species, .after = import)
nmino_import_clean <- import_clean_function(nmino_import) %>%
  dplyr::mutate(species = "Naso minor") %>%
  dplyr::relocate(species, .after = import)
pmult_import_clean <- import_clean_function(pmult_import) %>%
  dplyr::mutate(species = "Parupeneus multifasciatus") %>%
  dplyr::relocate(species, .after = import)
pleop_import_clean <- import_clean_function(pleop_import) %>%
  dplyr::mutate(species = "Plectropomus leopardus") %>%
  dplyr::relocate(species, .after = import)
ppisa_import_clean <- import_clean_function(ppisa_import) %>%
  dplyr::mutate(species = "Pterocaesio pisang") %>%
  dplyr::relocate(species, .after = import)
sglob_import_clean <- import_clean_function(sglob_import) %>%
  dplyr::mutate(species = "Scarus globiceps") %>%
  dplyr::relocate(species, .after = import)
scana_import_clean <- import_clean_function(scana_import) %>%
  dplyr::mutate(species = "Siganus canaliculatus") %>%
  dplyr::relocate(species, .after = import)

## 6a. Export data
export_clean_function <- function(data){
  
  export_data_cleaned <- data %>%
    dplyr::select(ScrInf) %>%
    dplyr::rename(export = ScrInf) %>%
    dplyr::mutate(iso3 = "PHL") %>%
    dplyr::relocate(iso3, .after = export)
  
  return(export_data_cleaned)
}

aline_export_clean <- export_clean_function(aline_export) %>%
  dplyr::mutate(species = "Acanthurus lineatus") %>%
  dplyr::relocate(species, .after = export)
ccaer_export_clean <- export_clean_function(ccaer_export) %>%
  dplyr::mutate(species = "Caesio caerulaurea") %>%
  dplyr::relocate(species, .after = export)
cblee_export_clean <- export_clean_function(cblee_export) %>%
  dplyr::mutate(species = "Chlorurus bleekeri") %>%
  dplyr::relocate(species, .after = export)
lehre_export_clean <- export_clean_function(lehre_export) %>%
  dplyr::mutate(species = "Lutjanus ehrenbergii") %>%
  dplyr::relocate(species, .after = export)
nmino_export_clean <- export_clean_function(nmino_export) %>%
  dplyr::mutate(species = "Naso minor") %>%
  dplyr::relocate(species, .after = export)
pmult_export_clean <- export_clean_function(pmult_export) %>%
  dplyr::mutate(species = "Parupeneus multifasciatus") %>%
  dplyr::relocate(species, .after = export)
pleop_export_clean <- export_clean_function(pleop_export) %>%
  dplyr::mutate(species = "Plectropomus leopardus") %>%
  dplyr::relocate(species, .after = export)
ppisa_export_clean <- export_clean_function(ppisa_export) %>%
  dplyr::mutate(species = "Pterocaesio pisang") %>%
  dplyr::relocate(species, .after = export)
sglob_export_clean <- export_clean_function(sglob_export) %>%
  dplyr::mutate(species = "Scarus globiceps") %>%
  dplyr::relocate(species, .after = export)
scana_export_clean <- export_clean_function(scana_export) %>%
  dplyr::mutate(species = "Siganus canaliculatus") %>%
  dplyr::relocate(species, .after = export)

## Generate and bind the quantile classifications of import / export values
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
aline_import_quantile <- import_quantile_function(aline_import_clean$import)
aline_import_classify <- import_classify_function(aline_import_clean,aline_import_quantile)

ccaer_import_quantile <- import_quantile_function(ccaer_import_clean$import)
ccaer_import_classify <- import_classify_function(ccaer_import_clean,ccaer_import_quantile)

cblee_import_quantile <- import_quantile_function(cblee_import_clean$import)
cblee_import_classify <- import_classify_function(cblee_import_clean,cblee_import_quantile)

lehre_import_quantile <- import_quantile_function(lehre_import_clean$import)
lehre_import_classify <- import_classify_function(lehre_import_clean,lehre_import_quantile)

nmino_import_quantile <- import_quantile_function(nmino_import_clean$import)
nmino_import_classify <- import_classify_function(nmino_import_clean,nmino_import_quantile)

pmult_import_quantile <- import_quantile_function(pmult_import_clean$import)
pmult_import_classify <- import_classify_function(pmult_import_clean,pmult_import_quantile)

pleop_import_quantile <- import_quantile_function(pleop_import_clean$import)
pleop_import_classify <- import_classify_function(pleop_import_clean,pleop_import_quantile)

ppisa_import_quantile <- import_quantile_function(ppisa_import_clean$import)
ppisa_import_classify <- import_classify_function(ppisa_import_clean,ppisa_import_quantile)

sglob_import_quantile <- import_quantile_function(sglob_import_clean$import)
sglob_import_classify <- import_classify_function(sglob_import_clean,sglob_import_quantile)

scana_import_quantile <- import_quantile_function(scana_import_clean$import)
scana_import_classify <- import_classify_function(scana_import_clean,scana_import_quantile)

phl_species_import <- rbind(aline_import_classify,
                            ccaer_import_classify,
                            cblee_import_classify,
                            lehre_import_classify,
                            nmino_import_classify,
                            pmult_import_classify,
                            pleop_import_classify,
                            ppisa_import_classify,
                            sglob_import_classify,
                            scana_import_classify)

# Larval export connectivity by species
aline_export_quantile <- export_quantile_function(aline_export_clean$export)
aline_export_classify <- export_classify_function(aline_export_clean,aline_export_quantile)

ccaer_export_quantile <- export_quantile_function(ccaer_export_clean$export)
ccaer_export_classify <- export_classify_function(ccaer_export_clean,ccaer_export_quantile)

cblee_export_quantile <- export_quantile_function(cblee_export_clean$export)
cblee_export_classify <- export_classify_function(cblee_export_clean,cblee_export_quantile)

lehre_export_quantile <- export_quantile_function(lehre_export_clean$export)
lehre_export_classify <- export_classify_function(lehre_export_clean,lehre_export_quantile)

nmino_export_quantile <- export_quantile_function(nmino_export_clean$export)
nmino_export_classify <- export_classify_function(nmino_export_clean,nmino_export_quantile)

pmult_export_quantile <- export_quantile_function(pmult_export_clean$export)
pmult_export_classify <- export_classify_function(pmult_export_clean,pmult_export_quantile)

pleop_export_quantile <- export_quantile_function(pleop_export_clean$export)
pleop_export_classify <- export_classify_function(pleop_export_clean,pleop_export_quantile)

ppisa_export_quantile <- export_quantile_function(ppisa_export_clean$export)
ppisa_export_classify <- export_classify_function(ppisa_export_clean,ppisa_export_quantile)

sglob_export_quantile <- export_quantile_function(sglob_export_clean$export)
sglob_export_classify <- export_classify_function(sglob_export_clean,sglob_export_quantile)

scana_export_quantile <- export_quantile_function(scana_export_clean$export)
scana_export_classify <- export_classify_function(scana_export_clean,scana_export_quantile)

phl_species_export <- rbind(aline_export_classify,
                            ccaer_export_classify,
                            cblee_export_classify,
                            lehre_export_classify,
                            nmino_export_classify,
                            pmult_export_classify,
                            pleop_export_classify,
                            ppisa_export_classify,
                            sglob_export_classify,
                            scana_export_classify)

######################################################
######################################################

### 7. Managed access and reserve data
phl_ma_clean <- phl_ma %>%
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::select(MUNNAME, PROVNAME, Area_ha, iso3) %>%
  dplyr::rename(snu = PROVNAME, ma_name = MUNNAME, ma_area = Area_ha)

phl_reserves_clean <- phl_reserves %>%
  dplyr::mutate(iso3 = "PHL") %>%
  dplyr::select(MPA_name, Area_ha, iso3) %>%
  dplyr::rename(reserve = MPA_name, area_ha = Area_ha)

######################################################
######################################################

### 8. Saving as a GeoPackage
st_write(phl, dsn = zev_dir, layer = 'country', append = F)

st_write(phl_reserves_clean, dsn = zev_dir, layer = 'reserves', append = F)
st_write(phl_ma_clean, dsn = zev_dir, layer = 'managed_access_areas', append = F)
# st_write(phl_pu, dsn = zev_dir, layer = 'planning_unit', append = F)

st_write(phl_pu_habitat_area, dsn = zev_dir, layer = "planning_grid", append = F)
st_write(phl_mangroves, dsn = zev_dir, layer = 'mangrove', append = F)
st_write(phl_coral, dsn = zev_dir, layer = 'reef', append = F)

st_write(phl_coral_quality, dsn = zev_dir, layer = 'habitat_quality_coral', append = F)
st_write(phl_seagrass_quality, dsn = zev_dir, layer = 'habitat_quality_seagrass', append = F)

# writeRaster(phl_antique_cr_hq, 
#              filename=file.path(paste0(zev_dir, "phl_antique_cr_hq.tif")),
#              overwrite = TRUE)
# writeRaster(phl_camotes_cr_hq, 
#             filename=file.path(paste0(zev_dir, "phl_camotes_cr_hq.tif")),
#             overwrite = TRUE)
# writeRaster(phl_escalante_cr_hq, 
#             filename=file.path(paste0(zev_dir, "phl_escalante_cr_hq.tif")),
#             overwrite = TRUE)
# writeRaster(phl_siargao_cr_hq, 
#             filename=file.path(paste0(zev_dir, "phl_siargao_cr_hq.tif")),
#             overwrite = TRUE)
# writeRaster(phl_siargao_sg_hq, 
#             filename=file.path(paste0(zev_dir, "phl_siargao_sg_hq.tif")),
#             overwrite = TRUE)

# st_write(aline_import_classify, zev_dir, "aline_larval_import", append = F)
# st_write(aline_export_classify, zev_dir, "aline_larval_export", append = F)
# st_write(ccaer_import_classify, zev_dir, "ccaer_larval_import", append = F)
# st_write(ccaer_export_classify, zev_dir, "ccaer_larval_export", append = F)
# st_write(cblee_import_classify, zev_dir, "cblee_larval_import", append = F)
# st_write(cblee_export_classify, zev_dir, "cblee_larval_export", append = F)
# st_write(lehre_import_classify, zev_dir, "lehre_larval_import", append = F)
# st_write(lehre_export_classify, zev_dir, "lehre_larval_export", append = F)
# st_write(nmino_import_classify, zev_dir, "nmino_larval_import", append = F)
# st_write(nmino_export_classify, zev_dir, "nmino_larval_export", append = F)
# st_write(pmult_import_classify, zev_dir, "pmult_larval_import", append = F)
# st_write(pmult_export_classify, zev_dir, "pmult_larval_export", append = F)
# st_write(pleop_import_classify, zev_dir, "pleop_larval_import", append = F)
# st_write(pleop_export_classify, zev_dir, "pleop_larval_export", append = F)
# st_write(ppisa_import_classify, zev_dir, "ppisa_larval_import", append = F)
# st_write(ppisa_export_classify, zev_dir, "ppisa_larval_export", append = F)
# st_write(sglob_import_classify, zev_dir, "sglob_larval_import", append = F)
# st_write(sglob_export_classify, zev_dir, "sglob_larval_export", append = F)
# st_write(scana_import_classify, zev_dir, "scana_larval_import", append = F)
# st_write(scana_export_classify, zev_dir, "scana_larval_export", append = F)

st_write(phl_species_export, zev_dir, "connectivity_nodes_export", append = F)
st_write(phl_species_import, zev_dir, "connectivity_nodes_import", append = F)
