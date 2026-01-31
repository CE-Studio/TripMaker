class_name EditorBeat
extends Node2D


#region Variables
const GRID_COLOR:Color = Color(1.0, 1.0, 1.0, 0.4)
const GRID_WIDTH:int = 4
const GRID_BORDER_WIDTH:int = 8
const TEXT_COLOR:Color = Color(1.0, 1.0, 1.0, 0.75)
const SECTION_NUM_SIZE:int = 64
const BEAT_NUM_SIZE:int = 20

var origin:Vector2 = Vector2(0.0, -200.0)
var grid_scale:Vector2 = Vector2(80.0, 28.0)
var grid_subdivs:Vector2 = Vector2(0.5, 1.0)
var vertical_divisions:int = 16
var vertical_section_size:int = 4
var horizontal_section_size:int = 8
var visible_extents:float = 800.0
var default_font:Font = ThemeDB.fallback_font
var cam_min_x:float = 0.0
var cam_max_x:float = 4000.0

var cam_x:float:
	get():
		if camera:
			return camera.position.x
		return 0.0
var cam_y:float:
	get():
		if camera:
			return camera.position.y
		return 0.0
var window_size:Vector2i:
	get():
		return get_viewport_rect().size

var global_mouse_position:Vector2 = Vector2.ZERO
var highlighted_position:Vector2 = Vector2.ZERO
var mouse_in_bounds:bool = false

@export var highlight:Node2D
@export var camera:Camera2D
@export var ui:Control
@export var beat_group:Node2D
#endregion


func move_highlight(new_pos:Vector2) -> void:
	mouse_in_bounds = false
	if new_pos.x >= 0.0 and new_pos.y >= 0.0 and new_pos.y < vertical_divisions:
		mouse_in_bounds = true
	highlight.position = Vector2(
		clampf(highlighted_position.x, 0.0, INF),
		clampf(highlighted_position.y, 0.0, vertical_divisions)
	) * grid_scale + origin


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var window:Vector2 = window_size
		var pos:Vector2 = Vector2(event.position)
		global_mouse_position = pos - Vector2(
			(window.x * 0.5) - cam_x + origin.x,
			(window.y * 0.5) - cam_y + origin.y
		)
		var scale_factors:Vector2 = Vector2(
			grid_scale.x * grid_subdivs.x,
			grid_scale.y * grid_subdivs.y
		)
		highlighted_position = Vector2(
			roundi(global_mouse_position.x / scale_factors.x) * grid_subdivs.x,
			roundi(global_mouse_position.y / scale_factors.y) * grid_subdivs.y,
		)
		move_highlight(highlighted_position)
	
		if Input.is_action_pressed(&"ui_pan") and camera:
			camera.position.x -= event.relative.x
			camera.position.x = clampf(camera.position.x, cam_min_x, cam_max_x)


func place_obj(obj:PackedScene, section:int, pos:Vector2) -> void:
	var new_obj:EditorObject = obj.instantiate()
	#if new_obj is BeatEditorObject:
	#	new_obj.type = EditorMain.instance.active_build_panel.selected_element
	#new_obj.section = section
	#new_obj.position = pos
	#EditorMain.section_data[section].objects.append(new_obj)
	#add_child(new_obj)


#func update_cam_max() -> void:
#	cam_max_x = GRID_SIZE.x * sections * SECTION_SIZE + (ORIGIN.x * 2)
