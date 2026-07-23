class_name EditorUI
extends Control


#region Variables
var build_panel_visible:bool:
	get():
		if active_build_panel:
			return active_build_panel.panel_visible
		return false

var last_save_label:String = ""
var level_unsaved:bool = false
var queue_test:bool = false

static var instance:EditorUI

static var section_data:Array[Section]
static var total_section_beats:int = 0
static var total_section_x:float = 0.0

@export var active_build_panel:BuildPanel
@export var main_scene:EditorBeat
@export var debug_label:RichTextLabel
@export var saved_label:RichTextLabel
@export var open_dialog:FileDialog
@export var save_dialog:FileDialog
#endregion


func _ready() -> void:
	instance = self
	saved_label.text = ""
	if main_scene:
		main_scene.edit_made.connect(_on_edit_made)
	assert(open_dialog, "Editor UI requires a FileDialog to open levels!")
	assert(save_dialog, "Editor UI requires a FileDialog to save levels!")
	open_dialog.visible = false
	save_dialog.visible = false


func _process(_delta: float) -> void:
	if main_scene and active_build_panel:
		debug_label.text = (
			"Highlighted position: " + str(main_scene.highlighted_position) + "\n" + 
			"Mouse within bounds: " + str(main_scene.mouse_in_bounds) + "\n" + 
			"Selected beat type: " + str(active_build_panel.selected_element) + "\n" + 
			"Objects on timeline: " + str(main_scene.objects.size())
		)


func set_saved_label_text(path:String, unsaved:bool = false) -> void:
	level_unsaved = false
	if path.strip_edges() == "":
		saved_label.text = "Unsaved*" if unsaved else ""
		last_save_label = ""
		level_unsaved = true
		return
	var path_parts:PackedStringArray = path.split("/")
	var lvl_name:String = path_parts[path_parts.size() - 1]
	lvl_name = lvl_name.replace(FileHandler.LEVEL_EXT, "")
	saved_label.text = lvl_name
	last_save_label = lvl_name
	if unsaved:
		saved_label.text = "*" + saved_label.text
		level_unsaved = true


func _on_edit_made() -> void:
	if not level_unsaved:# and last_save_label != "":
		set_saved_label_text(last_save_label, true)


func _on_new_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	Statics.editor_accepts_inputs = false
	add_child(load("uid://b2qr2w0f5q0bs").instantiate())


func _on_open_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	Statics.editor_accepts_inputs = false
	open_dialog.popup()


func _on_save_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	var file:FileHandler = FileHandler.instance
	if file.last_loaded_path != "":
		file.save_level(file.last_loaded_path, EditorBeat.instance.objects)
		set_saved_label_text(last_save_label, false)
	else:
		_on_save_as_pressed()


func _on_save_as_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	Statics.editor_accepts_inputs = false
	save_dialog.popup()


func _on_test_pressed() -> void:
	if not Statics.editor_accepts_inputs:
		return
	var file:FileHandler = FileHandler.instance
	if level_unsaved:
		if file.last_loaded_path == "":
			queue_test = true
			_on_save_as_pressed()
		else:
			file.save_level(file.last_loaded_path, EditorBeat.instance.objects)
			_change_to_game_scene()
	else:
		_change_to_game_scene()


func _on_open_dialog_file_selected(path:String) -> void:
	EditorBeat.instance.reset_all()
	FileHandler.instance.load_level(path)


func _on_save_dialog_file_selected(path:String) -> void:
	FileHandler.instance.save_level(path, EditorBeat.instance.objects)
	if queue_test: _change_to_game_scene()
	_on_dialog_cancelled()


func _on_dialog_cancelled() -> void:
	Statics.editor_accepts_inputs = true
	queue_test = false


func _change_to_game_scene() -> void:
	Statics.level_load_path = FileHandler.instance.last_loaded_path
	get_tree().change_scene_to_file("uid://oe0hoi334va7")


func _on_zoom_in_pressed() -> void:
	main_scene.increase_zoom()


func _on_zoom_out_pressed() -> void:
	main_scene.decrease_zoom()
