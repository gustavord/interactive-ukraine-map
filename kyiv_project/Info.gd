extends Panel

## INFO PANEL


## Function to update the panel with the selected oblast's information
func update_panel(state):
	var state_poly = state.get_node("Polygon2D")
	
	# Name of oblast on top
	$Name.text = state.name

	# Area polygon color
	$ColorSlider.selected = state_poly
	$ColorSlider.value = state_poly.color_val
	
	# Oblast unrest level
	$UnrestSlider.value = state.get_unrest()
	$UnrestSlider.selected = state
	
	# Text of oblast
	$TextEdit.selected = state
	$TextEdit.text = state.get_text_box()
