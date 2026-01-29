class_name BuildButton
extends TextureButton


@export var editor:BuildPanel
@export var my_element:int = -1


func _ready() -> void:
	if texture_normal:
		texture_hover = texture_normal
		texture_focused = texture_normal


func _on_pressed():
	if editor:
		if editor.selected_element == my_element:
			editor.set_selected(-1)
		else:
			editor.set_selected(my_element)
