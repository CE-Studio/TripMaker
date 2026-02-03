class_name EditorUI
extends Control


#region Variables
var build_panel_visible:bool:
	get():
		if active_build_panel:
			return active_build_panel.panel_visible
		return false

static var instance:EditorUI

static var section_data:Array[Section]
static var total_section_beats:int = 0
static var total_section_x:float = 0.0

@export var active_build_panel:BuildPanel
@export var main_scene:EditorBeat
@export var debug_label:RichTextLabel
@export var saved_label:RichTextLabel
#endregion


func _ready() -> void:
	instance = self
	saved_label.text = ""


func _process(_delta: float) -> void:
	if main_scene and active_build_panel:
		debug_label.text = (
			"Highlighted position: " + str(main_scene.highlighted_position) + "\n" + 
			"Mouse within bounds: " + str(main_scene.mouse_in_bounds) + "\n" + 
			"Selected beat type: " + str(active_build_panel.selected_element) + "\n" + 
			"Objects on timeline: " + str(main_scene.objects.size())
		)


func set_saved_label_text(path:String) -> void:
	if path.strip_edges() == "":
		return
	var path_parts:PackedStringArray = path.split("/")
	saved_label.text = path_parts[path_parts.size() - 1]


func _on_new_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	Statics.editor_accepts_inputs = false
	add_child(load("uid://b2qr2w0f5q0bs").instantiate())


func _on_open_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	pass


func _on_save_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	pass


func _on_save_as_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	pass


func _on_test_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	pass
