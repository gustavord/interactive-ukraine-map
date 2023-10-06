extends AudioStreamPlayer

# Preloading all sounds to be used in the scene
onready var mouse_over = preload("res://assets/hover.ogg") # Played when mouse pointer enters an area

onready var delete_arrow = preload("res://assets/delete_arrow.ogg") # Played when an arrow is deleted

onready var select :=[preload("res://assets/select_0.ogg")#
					,preload("res://assets/select_1.ogg") #
					,preload("res://assets/select_2.ogg") #
					,preload("res://assets/select_3.ogg") #	Played when an area is selected
					,preload("res://assets/select_4.ogg") #
					,preload("res://assets/select_5.ogg") #
					,preload("res://assets/select_6.ogg")]#


func play_mouse_over():
	stream = mouse_over
	play()

## Plays a random sound from the list
func play_selected():
	stream = select[randi() % select.size()]
	play()

func play_arrow_deleted():
	stream = delete_arrow
	play()
