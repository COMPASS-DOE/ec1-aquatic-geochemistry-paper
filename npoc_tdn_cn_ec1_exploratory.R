#### load in packages #####
library (ggplot2)
library (dplyr)
library (tidyverse)
library (readxl)
library (googledrive)
library (googlesheets4)
library (httpuv)
library (pacman)
library (janitor)
library (stringr)
library (stringi)

#### read in npoc/tn data and site metadata ####
npoc_tdn <- read.csv("~/R/EC1_Water_NPOC_TDN_L0B_20220601.csv") %>% #npoc/tn data
  select("kit_id","npoc_mgl", "tdn_mgl")

region_csv <- read.csv("~/R/EC1_Metadata_KitLevel.csv") %>% #water lat, long
  select("kit_id", "region")

#### joining regional metadata and npoc/tn data ####
npoc_tdn_ec1_region <- left_join(npoc_tdn, region_csv, by = "kit_id") #joining by kit_id to connect npoc/tn concentrations w coords

write.csv(npoc_tdn_ec1_region, "npoc_tdn_ec1_region.csv")

#### making exploratory npoc, tn plots ####

ggplot(npoc_tdn_ec1_region, aes(x= region, y= npoc_mgl)) +
  geom_boxplot() + geom_jitter() + theme_bw() #making box plot for npoc vs region

npoc_tdn_region_gl <- npoc_tdn_ec1_region %>% 
  filter(region !="Chesapeake Bay") 

ggplot(npoc_tdn_region_gl, aes(x= region, y= npoc_mgl)) +
  geom_boxplot() + geom_jitter() + theme_bw() #making box plot for npoc in gl

npoc_tdn_region_cb <- npoc_tdn_ec1_region %>% 
  filter(region != "Great Lakes")

ggplot(npoc_tdn_region_cb, aes(x= region, y=npoc_mgl)) +
           geom_boxplot() + geom_jitter() + theme_bw() #making box plot for npoc in cb

ggplot(npoc_tdn_ec1_region, aes(x= region, y= tdn_mgl)) +
  geom_boxplot() + geom_jitter() + theme_bw() #making box plot for tn in cb

ggplot(npoc_tdn_region_cb, aes(x= npoc_mgl)) + 
  geom_histogram(binwidth=.5, colour="black", fill="white") + 
  geom_vline(aes(xintercept=mean(npoc_mgl, na.rm=T)),   # Ignore NA values for mean
             color="red", linetype="dashed", size=1)

ggplot(npoc_tdn_region_gl, aes(x= npoc_mgl)) + 
  geom_histogram(binwidth=.5, colour="black", fill="white") + 
  geom_vline(aes(xintercept=mean(npoc_mgl, na.rm=T)),   # Ignore NA values for mean
             color="red", linetype="dashed", size=1)

ggplot(npoc_tdn_region_cb, aes(x= tdn_mgl)) + 
  geom_histogram(binwidth=.5, colour="black", fill="white") + 
  geom_vline(aes(xintercept=mean(tdn_mgl, na.rm=T)),   # Ignore NA values for mean
             color="red", linetype="dashed", size=1)

ggplot(npoc_tdn_region_gl, aes(x= tdn_mgl)) + 
  geom_histogram(binwidth=.5, colour="black", fill="white") + 
  geom_vline(aes(xintercept=mean(tdn_mgl, na.rm=T)),   # Ignore NA values for mean
             color="red", linetype="dashed", size=1)
#### joining coords with npoc and tdn values for qgis ####

ec1_coord <- read.csv("~/R/EC1_Metadata_CollectionLevel.csv") %>% #csv with water collection specific coordinates
  select("kit_id", "water_latitude", "water_longitude") 
  

npoc_tdn <- read.csv("~/R/EC1_Water_NPOC_TDN_L0B_20220601.csv") %>% #npoc tdn conc
  select("kit_id","npoc_mgl", "tdn_mgl") 
 

npoc_tdn_coords <- left_join(npoc_tdn, ec1_coord, by = "kit_id") #joining by kit id 

write.csv(npoc_tdn_coords, "npoc_tdn_coords.csv")
 
