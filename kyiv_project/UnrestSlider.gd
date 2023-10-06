extends VSlider

## UNREST LEVEL SLIDER ##

var selected # Currently selected area

# Wicked math to translate the slider's value into an equivalent position
onready var slide_offset_y = (self.rect_position.y + self.rect_size.y - $Percentage.rect_position.y)/100
onready var grabber_offset_y = $Percentage.rect_position.y


## Function to modulate a color between green and red
func make_color(val):
	var red = val/100.0
	var green = (100 - val)/100.0
	var color = Color(red,green,0,1)
	return color

## Function to input the slider's value to the make_color() function and
## make the percentage label follow the grabber
func _on_UnrestSlider_value_changed(value):
	var color_val = make_color(value)
	
	$Percentage.rect_position.y = -self.value/slide_offset_y + grabber_offset_y
	
	# Apply the created color to the unrest percentage label
	$Percentage.set("custom_colors/font_color", color_val)
	
	# Set the label's text as the percentage
	$Percentage.text = str(value) + "%"

## Update the oblast's unrest level variable when drag ends
func _on_UnrestSlider_drag_ended(_value_changed):
	selected.set_unrest(self.value)
