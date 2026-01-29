class_name EditorTimeline
extends Node2D


#region Variables
const GRID_COLOR:Color = Color(1.0, 1.0, 1.0, 0.4)
const GRID_WIDTH:int = 4
const GRID_BORDER_WIDTH:int = 8
const TEXT_COLOR:Color = Color(1.0, 1.0, 1.0, 0.75)
const SECTION_NUM_SIZE:int = 64
const BEAT_NUM_SIZE:int = 20

var origin:Vector2 = Vector2.ZERO
var highlighted_position:Vector2 = Vector2.ZERO
var sections:int = 4

var default_font:Font = ThemeDB.fallback_font

@export var main_editor:EditorScene
@export var sidescrolling:bool = false
@export var highlight:Node2D
#endregion


func _ready() -> void:
	if main_editor:
		for i in range(sections):
			main_editor.append_section()


func move_highlight(new_pos:Vector2) -> void:
	if highlight:
		highlight.position = new_pos
	highlighted_position = new_pos


func place_obj(obj:PackedScene, section:int, pos:Vector2) -> void:
	var new_obj:EditorObject = obj.instantiate()
	if new_obj is BeatEditorObject:
		new_obj.type = EditorMain.instance.active_build_panel.selected_element
	new_obj.section = section
	new_obj.position = pos
	new_obj.timeline = self
	EditorMain.section_data[section].objects.append(new_obj)
	add_child(new_obj)
