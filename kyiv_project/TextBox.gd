extends TextEdit

## INFO PANEL TEXT BOX ##

var selected # Currently selected area

## Update the state's text box variable (used for saving)
func _on_TextEdit_text_changed():
	selected.set_text_box(text)
