rm(list=ls(all=TRUE)) # clear memory



packages<- c("rgdal","raster","RgoogleMaps") # list the packages that you'll need

#install.packages(packages) Uncomment out if packages are not installed already
lapply(packages, require, character.only=T) # load the packages, if they don't load you might need to install them first



#download: http://bit.ly/2fwuxTL

setwd("N:/Teaching/Workshops/SpatialR") #Enter the folder where you extracted the zip file here

#1). Vector Data:
#Open a shapefile
us.states <- readOGR("Data", "STATES")   #The first part is the folder, the second part is the file name minus extension
#Quick plot of the data
plot(us.states)


# Get some basic information about the vector data
proj4string(us.states)	# projection / CRS: coordinate reference system
bbox(us.states)	# bounding box
nrow(us.states) #number of features

#to access the data from a spatial data frame use @data
us.states.table <- us.states@data




#Raster Data
dem <- raster("Data//NLCD2000_DEM.tif")
plot(dem)
extent(dem)
res(dem)
projection(dem)
dem.data <- getValues(dem)

landsat <- raster("Data//NLCD2000_multi.tif")
plot(landsat)
landsat <-brick("Data//NLCD2000_multi.tif")
plotRGB(landsat,r=3,g=2,b=1, stretch =  "lin")


# cell number and values from coordinate
cell <- cellFromXY(landsat, cbind(563706,4616869))	# get cell number from coordinates
cell.ts <- landsat[cell]	# get values for this cell
cell.ts

# or coordinates from cell number
xyFromCell(landsat, 56559)

# click on raster cells to get values:
values <- click(landsat, n=1, xy=TRUE)	# click into the map to get values and coordinates
values


latlong <- "+init=epsg:4326" #This is the espg code for the WGS 1984 geographic projection
google <- "+init=epsg:3857"  #This is the espg code for the web mercator projection used by google earth


#creating a spatial object from a table
water.sites <- read.csv("Data\\Water_Sites.csv")  #Read the table with Lat and lon
coordinates(water.sites) <- ~LON + LAT             #Define the coordinates to convert it to a spatial points data frame
proj4string(water.sites) <- CRS(latlong)           #Define the projection using the CRS command to convert the string with the EPSG code
plot(water.sites)

writeOGR(obj = water.sites, dsn= "Data", layer = "water_sites", driver="ESRI Shapefile") #writes the spatial points data frame as a shapefile

#Reprojecting the water sites to match the raster data
water.sites_UTM = spTransform(water.sites, CRS(proj4string(dem)))
plot(water.sites_UTM)

# Transform/Warp Raster
dem_latlong = projectRaster(dem, crs = latlong)


#Plotting

# 'contour' plot 
contour(dem)

# or combine plot and contour
plot(dem, col=terrain.colors(25))
contour(dem, add=TRUE)

#Working with web data
map <- GetMap(center=c(41.70566,-86.2353), zoom=14, destfile = "ND_google.png", maptype = "mobile") #other maptypes are satellite, hybrid and terrain
PlotOnStaticMap(map)	# plotting function from the RgoogleMaps package


#Functions
#Raster:
#Aggrigate: Decrease resolution
dem.agg <- aggregate(dem, fact=10)
plot(dem.agg)

#extract the mean elevation around each water sample
water.mean.elevation <- extract(dem, water.sites_UTM, buffer = 100,df = TRUE, fun = mean) #uses the extract command from the raster package
names(water.mean.elevation)<-c("ID","mn_elev100")
#merge this back on to the table for the original watersites shapefile
library("sp") #this is necessary for the merge
water.sites_UTM@data$ID <- row.names(water.sites_UTM@data)
water.sites.export <- merge(water.sites_UTM,water.mean.elevation, by="ID")
writeOGR(obj = water.sites.export, dsn= "Data", layer = "water_sites_withElev", driver="ESRI Shapefile") #writes the spatial points data frame as a shapefile

#Creating interactive objects
library(leaflet)


leaflet()  %>%
  addTiles()  %>%
  addMarkers(data = water.sites)
         

leaflet()  %>%
  addTiles()  %>%
  addProviderTiles(providers$Stamen.Watercolor, group = "Art") %>%
  addCircleMarkers(data = water.sites, popup = ~STATION,group="Water Sites",color = "#EF5B5B",radius=4, opacity = .8) %>%
  addLayersControl(
    baseGroups = c("Basic", "Art"),
    overlayGroups= c("Water Sites"),
    options = layersControlOptions(collapsed = FALSE)
  )       

  
