extends Label

## ARROW DRAWING TOOLTIP ##

func _on_DrawArrow_mode(ctrl_pressed):
	if ctrl_pressed:
		text = "Cycle through arrows with mouse wheel or arrow keys and click the right mouse button to delete."
	else:
		text = "Hold and drag the right mouse button to draw an arrow \n \n Hold CTRL to delete arrows"

