extends CanvasLayer

## HANDLER FOR THE SELECTED AREA
## Indicates which area is selected, saves and updates the relevant elements

# Globalization of file pathing so the save file is created and read from the same folder as the .exe
var exe_path = ProjectSettings.globalize_path("res://")
var file_path = exe_path + "oblasts.save"

onready var panel = get_node("Control/Panel") # Info panel
var chosen
var last_chosen


## On startup, tries to load the save file for oblast infos. If unsuccessful,
## initializes with default values. Connects the "clicked" signal emitted by the Areas
## to itself through the _on_area_clicked function.
func _ready():
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	if load_info(file_path) == false:
		# Couldn't load file
		for child in self.get_children():
			if(child is Area2D):
					init_info(child)
					child.connect("clicked", self, "_on_area_clicked")
	chosen = self.get_child(3) # Lviv
	panel.update_panel(chosen)


## Saves the color and unrest values of each state into a text (.save) file.
## If any text has been input in the text box, indicates it with ";/" and writes
## the text to the following line (or lines, if the string contains line breaks.).
func save_oblasts(filename):
	var file = File.new()
	if file.open(filename, File.WRITE) == OK:
		for child in self.get_children():  # Iterate through all children
			if child is Area2D:
				var oblast_unrest = child.get_unrest()
				var oblast_text_box = child.get_text_box()
				var poly_color = child.get_child(1).get_color_val()
				# Empty space as separator
				var line_data = str(child.name) + " " + str(poly_color) + " " + str(oblast_unrest)
				
				# Area has text
				if oblast_text_box != " ":
					line_data = line_data  + " ;/\n" + oblast_text_box + "\n/;"

				file.store_line(line_data)
		print("Oblast infos saved.")
		file.close()


## Loads data from the save file and connects
func load_info(filename):
	var file = File.new()
	if file.open(filename, File.READ) == OK:
		while !file.eof_reached(): # Do until End Of File reached
			var line_data = file.get_line()
			
			if line_data != "": # If line is not empty
				var split_data = line_data.split(" ")
				
				var oblast = get_node(split_data[0])  # Name of oblast
				var polygon = oblast.get_child(1)	 
				polygon.set_color(int(split_data[1])) # Color of the area's polygon
				oblast.set_unrest(int(split_data[2])) # Unrest value of oblast
				
				if split_data.size() > 3: # If there's one more item
					if split_data[3] == ";/": # Make sure it's the text box flag
						
						var string_build = ""
						var next = file.get_line()
						while(next != "/;"): # Get the strings until the end flag is reached
							string_build += next + "\n"
							next = file.get_line()
						oblast.set_text_box(string_build) # Set the text box's text as the string built

				# Connects each area to the signal function
				oblast.connect("clicked", self, "_on_area_clicked")
		file.close()
		return true  # Load successful
	else:
		return false # Load failed

## Initializes oblast values with default values, used when no save file is loaded.
func init_info(oblast):
	oblast.set_unrest(0)
	
	var oblast_poly = oblast.get_child(1) # Area polygon
	
	oblast_poly.set_color(0)
	""" Arbitrary values
	
	match(oblast.name):
		"Zakarpattia":
			oblast_poly.set_color(23)
		"Lviv":
			oblast_poly.set_color(50)
		"Volyn":
			oblast_poly.set_color(1)
		"Rivne":
			oblast_poly.set_color(0)
		"Kyiv":
			oblast_poly.set_color(0)
		"Chernihiv":
			oblast_poly.set_color(0)
		"Sumy":
			oblast_poly.set_color(0)
		"Zhytomyr":
			oblast_poly.set_color(0)
		"Ivano-Frankivsk":
			oblast_poly.set_color(0)
		"Chernivtsi":
			oblast_poly.set_color(0)
		"Ternopil":
			oblast_poly.set_color(0)
		"Khmelnytskyi":
			oblast_poly.set_color(0)
		"Vinnytsia":
			oblast_poly.set_color(0)
		"Cherkasy":
			oblast_poly.set_color(0)
		"Kirovohrad":
			oblast_poly.set_color(0)
		"Odessa":
			oblast_poly.set_color(60)
		"Crimea":
			oblast_poly.set_color(0)
		"Sevastopol":
			oblast_poly.set_color(0)
		"Mykolaiv":
			oblast_poly.set_color(0)
		"Kherson":
			oblast_poly.set_color(0)
		"Zaporizhzhia":
			oblast_poly.set_color(30)
		"Donetsk":
			oblast_poly.set_color(0)
		"Dnipropetrovsk":
			oblast_poly.set_color(0)
		"Poltava":
			oblast_poly.set_color(0)
		"Kharkiv":
			oblast_poly.set_color(0)
		"Luhansk":
			oblast_poly.set_color(0)
		"""		
		

## Receives signal from the clicked area and indicates it is the selected one.
func _on_area_clicked(area):
	last_chosen = chosen
	chosen = area
	last_chosen.update() # Updates draw() of the last area so it's no longer highlighted
	panel.update_panel(area) # Updates the info panel with the chosen area's info
