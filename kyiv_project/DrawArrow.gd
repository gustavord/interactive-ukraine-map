extends Control

## NODE FOR CREATING AND DELETING ARROWS ##


# Globalization of file pathing so the save file is created and read from the same folder as the .exe
var exe_path = ProjectSettings.globalize_path("res://")
var file_path = exe_path + "arrows.save"

# Loading the audio node to play the sound for deleting arrows
onready var audiostream = get_parent().get_parent().get_node("audio")

var arrow
var line
var arrowhead

var index

var ctrl_pressed = false
var drawing = false

var arrow_color = Color(0.11, 0.535, 0.11, 1) # Custom green to match arrow point texture
var highlighted_color = Color(1, 1, 1, 1)	  # White

signal mode

## Corrects the position offset of get_global_mouse_position to better fit the actual mouse pointer position
func offset_position(position):
	return Vector2(position.x-10, position.y -15)

## Handles inputs for creating arrows and arrow deletion mode 
func _input(event):
	
	# Holding RMB and dragging creates an arrow and starts the drawing
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			
			# If not in arrow deletion mode or already drawing, start drawing arrow
			if !ctrl_pressed:
				if !drawing:
					line = create_arrow(event.position)
					arrowhead = line.get_child(0)
					drawing = true
			
			else: # In arrow deletion mode
				if arrow != null and get_child_count() > 0:
					remove_child(arrow)	
					audiostream.play_arrow_deleted()
					
		# After deleting the selected arrow, another one must be selected unless there aren't any more 
					if index == 0:
						if get_child_count() > 1:
							index = index + 1
					else:
						index = index - 1
		
		# RMB not pressed, then not drawing
		else:
			drawing = false
				
	
	# Holding CTRL enables arrow deletion mode
	if(event is InputEventKey and event.scancode == KEY_CONTROL and not event.echo):
		if(event.is_pressed()):
			# If there are arrows
			if(self.get_child_count() > 0):
				ctrl_pressed = true
				emit_signal("mode", ctrl_pressed)
				
				index = get_child_count() - 1 # Start with the last arrow created selected
				arrow = self.get_child(index) # Gets the arrow at index
				arrow.set_default_color(highlighted_color) # Sets the line color as white
				
		else: # CTRL not pressed
			if arrow != null:
				# Set the arrow (if any) color to green again
				arrow.set_default_color(arrow_color)
			ctrl_pressed = false
			emit_signal("mode", ctrl_pressed)
			
	# Cycling through the arrows in deletion mode with the mouse wheel or up and down keys.
	# Cycle wraps around.
	if((Input.is_action_just_pressed("mwup") or
	Input.is_action_just_pressed("ui_up")) and 
	ctrl_pressed 
	and get_child_count() > 0):
		arrow.set_default_color(arrow_color)
		if(index == self.get_child_count() - 1):
			index = 0
		else:
			index = index + 1
		arrow = self.get_child(index)
		arrow.set_default_color(highlighted_color)
		
	if((Input.is_action_just_pressed("mwdown") or 
	Input.is_action_just_pressed("ui_down")) and 
	ctrl_pressed and 
	get_child_count() > 0):
		arrow.set_default_color(arrow_color)
		if(index == 0):
			index = self.get_child_count() - 1
		else:
			index = index - 1
		arrow = self.get_child(index)
		arrow.set_default_color(highlighted_color)
	
## Function to create an arrow with Line2d and a triangle sprite
func create_arrow(position):
	line = Line2D.new()
	add_child(line)

	arrowhead = Sprite.new()
	arrowhead.texture = preload("res://assets//triangle.png")
	arrowhead.scale = Vector2(0.013, 0.013)
	
	 # Sets arrow point as child of the line. Easier when deleting the arrow later.
	line.add_child(arrowhead)
	
	line.width = 3
	line.set_default_color(arrow_color)

	# Correcting the mouse position offset
	var offset_pos = offset_position(position)
	line.add_point(offset_pos)
	line.add_point(offset_pos)
	arrowhead.position = offset_pos
	
	return line

## Updates the line point position and the arrow point's position on every frame process
## so the arrow drawing is in real time
func _process(_delta):
	if drawing:
		line.set_point_position(line.points.size()-1,offset_position(get_global_mouse_position()))
		arrowhead.position = offset_position(get_global_mouse_position())
		
		# The arrow point's rotation is defined by the angle between the two points of the line and the
		# rotation correction of the triangle sprite. 
		arrowhead.set_rotation(line.get_point_position(0).angle_to_point(line.get_point_position(1))-1.57079633)

## Saves each arrow's line's position and arrow point's rotation
func saveLinePoints(filename):
	var file = File.new()
	if file.open(filename, File.WRITE) == OK:
		for child in get_children():
			if child is Line2D:
				for i in range(child.get_point_count()):
					var point = child.get_point_position(i)
					
					# Store position as x and y values as text files don't support Vector2
					# Empty space as separator
					var line_data = str(point.x) + " " + str(point.y)
					file.store_line(line_data)
					
				var arrow_ = child.get_child(0)
				file.store_line(str(arrow_.rotation)) # In radians
		print("Arrows saved.")
		file.close()

## Loads the saved arrows' (if any) data and creates arrows with it
func loadLinePoints(filename):
	var file = File.new()
	if file.open(filename, File.READ) == OK:
		while !file.eof_reached():
			var line_data = file.get_line()
			var split_data = line_data.split(" ")
			
			if line_data != "":
			
				var x1 = float(split_data[0])
				var y1 = float(split_data[1])
				
				line_data = file.get_line()
				split_data = line_data.split(" ")
				
				var x2 = float(split_data[0])
				var y2 = float(split_data[1])
				
				var pos1 = Vector2(x1, y1)
				var pos2 = Vector2(x2, y2)
				
				line = Line2D.new()
				add_child(line)
				
				line.width = 3
				line.set_default_color(arrow_color)
				
				line.add_point(pos1)
				line.add_point(pos2)
				
				var arrow_ = Sprite.new()
				arrow_.texture = preload("res://assets//triangle.png")
				arrow_.scale = Vector2(0.013, 0.013)
				arrow_.position = pos2
				arrow_.set_rotation(float(file.get_line())) 
				
				line.add_child(arrow_)

		print("Loaded arrows")
		file.close()

## Attempts to load an arrow data save file
func _ready():
	loadLinePoints(file_path)
