extends Button

## SAVE BUTTON ##

# Globalization of file pathing so the save file is created and read from the same folder as the .exe
var exe_path = ProjectSettings.globalize_path("res://")

## Call both save functions when pressed
func _on_SaveButton_pressed():
	var canvas_layer = self.get_parent().get_parent()
	var draw_arrow = canvas_layer.get_node("DrawArrow")
	
	canvas_layer.save_oblasts(exe_path + "oblasts.save")
	draw_arrow.saveLinePoints(exe_path + "arrows.save")
