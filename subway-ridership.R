if (!require(tidyverse)) install.packages("tidyverse"); library(tidyverse)
if (!require(haven)) install.packages("haven"); library(haven)
if (!require(ggplot2)) install.packages("ggplot2"); library(ggplot2)
if (!require(statar)) install.packages("statar"); library(statar); library(sf)
if (!require(raster)) install.packages("raster"); library(raster)
if (!require(dplyr)) install.packages("dplyr"); library(dplyr)
if (!require(spData)) install.packages("spData"); library(spData)
if (!require(spDataLarge)) install.packages("spDataLarge"); library(spDataLarge)
if (!require(tmap)) install.packages("tmap"); library(tmap)
if (!require(spData)) install.packages("spData"); library(spData)
if (!require(gifski)) install.packages("gifski"); library(gifski)

survey_rail <- read_dta("ridership.dta")
survey_rail$city_code <- sapply(survey_rail$urbancode, as.double)
survey_rail$ridership <- rowSums(cbind(survey_rail$ridershipheavyrail, survey_rail$ridershipbuses, survey_rail$ridershiplightrail), na.rm=T)
survey_rail$ridership[survey_rail$ridership == 0] <- survey_rail$ridership_all[survey_rail$ridership == 0]
city_geo <- urban_agglomerations[c("city_code","geometry")]
merged <- left_join(survey_rail, city_geo, by="city_code")
merged <- st_as_sf(merged)
urb_anim = tm_shape(world) + tm_polygons() + 
  tm_shape(merged) + tm_dots(size = "ridership", col = "brown", alpha=0.5, scale=2) +
  tm_facets(along = "year", free.coords = FALSE, drop.NA.facets = TRUE) + tm_style("classic")
tmap_animation(urb_anim, filename = "urb_anim.gif", delay = 50)


