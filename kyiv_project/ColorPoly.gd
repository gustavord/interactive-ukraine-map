extends Polygon2D

var color_val = 50 # Initializes the color variable (0 to 100)

# On startup, sets the position and vertices of the polygon the same as
# its pre-defined CollisionPolygon parent.
func _ready():	
	var info = self.get_parent().getPoly()
	self.polygon = info[0]
	self.position = info[1]

func set_color_val(val):
	color_val = val
	
func get_color_val():
	return color_val

## Converts a value of range 0-100 to 0-1 to modulate between blue and red.
func set_color(val):
	var red = val/100.0
	var blue = (100 - val)/100.0
	color = Color(red,0,blue,1)
	set_color_val(val) # Updates the color variable
