extends HSlider

var selected # Selected area's polygon

## Inputs the slider's current value to the polygon's color modulate function
func _on_ColorSlider_value_changed(value):
	selected.set_color(value)

## Updates the polygon's local variable so the slider's grabber can be set to the correct position.
func _on_ColorSlider_drag_ended(_value_changed):
	selected.set_color_val(self.value)
