class_name BuildPanel
extends Control


#region Variables
var panel_visible:bool = false

@export var editor_obj:PackedScene
@export var toggle_button:Button
@export var palette:Container
@export var selected_label:RichTextLabel

static var selected_element:int = -1
#endregion


func _ready() -> void:
	if palette:
		palette.visible = false
	if selected_label:
		selected_label.text = ""


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_toggle"):
		toggle_palette()


func toggle_palette() -> void:
	panel_visible = not panel_visible
	palette.visible = panel_visible
	toggle_button.text = "V V V" if panel_visible else "^ ^ ^"


func set_selected(element_id:int) -> void:
	selected_element = element_id
	if element_id == -1:
		selected_label.text = ""
	else:
		selected_label.text = Statics.BEAT_DATA_DICT[element_id][0]
