
#Example 1: Variables (Highlight the section below and press alt-4 to uncomment)
##name = "Oswald"         #This variable is a string, or normal text
##number_of_cats = 12     #This variable is an integer
##cat_food = ["fish", "kibbles", "biscuits", "cauliflower"]   #This variable is a list of other values
##
##
##print "His name is " + name + " and he has " + str(number_of_cats) + " cats"    #In order to combine them, we have to convert the integer to a string with the str() function


#Example 2: Testing logic
##if number_of_cats < 5 :
##    print name + " has a reasonable number of pets"
##elif number_of_cats == 5:
##    print name + " is approaching the limit of too many pets"
##else:
##    print name + " has far too many pets"
##
##var = "awsome"
##if var == "awesome":
##    print ("This is awesome")                   #There are also different ways of printing strings, the () are completely optional
##else:
##    print "This is somewhat less than awesome"


#Example 3: Iterating
##x = 1
##while x < 5:
##    print x,        #The comma at the end keeps it from going to the next line
##    x = x +1
##print               #The final print pushes it to the next line
##
##z = [1,1,2,3,5,8,13,21]
##for each_number in z:
##    print each_number,
##print


#Example 4: Importing modules

##import math     #gives you access to all of the function defined in the math module
##q = 100
##print math.sqrt(q)  #sqrt is a funtion defined in the math module
##
##import random
##cat_meal = random.choice(cat_food)
##print "Today, the cats are eating: " + cat_meal



#Example 5: A simple geoprocessing script
##import arcpy
##input_file = "c://Temp//Cities.shp"
##
##desc = arcpy.Describe(input_file)                           #Builds a description of the file
##number_features = arcpy.GetCount_management(input_file)
##
##print "This is a " + desc.shapeType + " shapefile with " + str(number_features) + " features"
##print "This is a {0} shapefile with {1} features".format(desc.shapeType, number_features)


#Example 6: A more complicated geoprocessing script
##
### Import ArcPy
##import arcpy
##
### Set environmental variables
##arcpy.env.workspace = "C:/Temp"         #Sets the default folder to look for files and create outupts
##arcpy.env.overwriteOutput = True        #Allows overwriting of prexisting files
##
##output_file = "Cities_buffer.shp"
##
### Execute Geoprocessing tool
##arcpy.Buffer_analysis(input_file, output_file, "50 Meters")

#Example 7: Dealing with errors

#Common error #1 : Syntax
##"blue" = my_variable

#Common error #2 : Extensions must have their licences verified before use
##arcpy.CheckOutExtension("Spatial")
##
##
##import arcpy
### Start Try block
##try:
##     arcpy.Buffer_analysis("Roads.shp", output_file, "50 Meters")
### If an error occurs
##except:
##    # Print that Buffer failed and why
##    print("Buffer failed")
##    print(arcpy.GetMessages(2))


#Example 8: Batch Processing

##arcpy.env.workspace = "N:\Lab04_DemoData"
##dsList = arcpy.ListFeatureClasses()
##print "Vector Data in: " + arcpy.env.workspace + " : "
##for ds in dsList:
##    print("   " + ds)
##
##dsList = arcpy.ListRasters()
##print "Raster Data in: " + arcpy.env.workspace + " : "
##for ds in dsList:
##    print("   " + ds)

#Example 9: Describine Data
##desc = arcpy.Describe(input_file)
##
##print "Data Type: " + desc.dataType
##print "Shape Type: " + desc.shapeType
##print "File Path: " + desc.path
##print "Spatial Reference: " + desc.spatialReference.name

#Example 9: Create variables from input arguments
##inputFC = arcpy.GetParameterAsText(0)
##outputFC = arcpy.GetParameterAsText(1)
##
### First and third parameters come from arguments
##arcpy.Clip_analysis(inputFC, "C:/Temp/Cities.shp", outputFC)

