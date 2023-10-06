extends Area2D

## SCRIPT FOR EACH OBLAST AREA ##

var unrest # Unrest level

var text_box = " "

var mouse_over = false   # Indicator of mouse over area
var global_vertices = [] # Collision polygon vertices

onready var audiostream = get_parent().get_parent().get_node("audio") # Audio player
signal clicked # Signal emitted to the handler to indicate this area has been selected

## Function that returns the vertices and position of the collision polygon;
## Used to create the solid polygons
func getPoly():
	var collision_polygon = get_node(self.get_child(0).get_path()) 
	return [collision_polygon.polygon, collision_polygon.position]

func set_unrest(value):
	unrest = value

func get_unrest():
	return unrest

func set_text_box(string):
	text_box = string

func get_text_box():
	return text_box

## Function to draw the areas' outlines (borders)
func _draw():
	draw_polyline(global_vertices, Color(0, 0, 0), 3) # Black outline
	if(mouse_over):
		_draw_mouse_over() # White outline when mouse is over area
	if(self == self.get_parent().chosen):
		draw_selected() 	# Green outline when selected


func _draw_mouse_over():
	draw_polyline(global_vertices, Color(1, 1, 1), 3) # White

func draw_selected():
	draw_polyline(global_vertices, Color(0, 1, 0), 5) # Green


## When mouse is detected inside the area, flag it, play a sound and redraw the outline
func _on_Area2D_mouse_entered():
	mouse_over = true;
	audiostream.play_mouse_over()
	update()

## When area is clicked, signal the handler, play a sound and redraw the outline
func _input(event):
	if(mouse_over and 
	event is InputEventMouseButton and 
	event.is_pressed() and 
	event.button_index == BUTTON_LEFT):
		emit_signal("clicked", self)
		audiostream.play_selected()

## When mouse leaves the area, redraw the outline 
func _on_Area2D_mouse_exited():
	mouse_over = false;
	update()

## On startup, converts the polygon into an array of vertices
func _ready():
	var collision_polygon = get_node(self.get_child(0).get_path())
	var vertices = collision_polygon.polygon
		
	for vertex in vertices:
		global_vertices.append(collision_polygon.to_global(vertex))
