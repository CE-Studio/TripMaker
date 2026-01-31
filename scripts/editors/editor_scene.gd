class_name EditorScene
extends Node2D


#region Variables
const CAM_MIN_X:float = 0.0

var cam_max_x:float = 4000.0

var cam_x:float:
	get():
		if camera:
			return camera.position.x
		return 0.0
var window_size:Vector2i:
	get():
		return get_viewport_rect().size

static var instance:EditorScene

@export var ui_main:EditorUI
@export var active_timeline:EditorTimeline
@export var camera:Camera2D
#endregion


func _ready() -> void:
	instance = self
	if active_timeline:
		active_timeline.main_editor = self


func _input(event: InputEvent) -> void:
	var scroll:bool = active_timeline and active_timeline.sidescrolling
	
	if event is InputEventMouseMotion:
		if active_timeline:
			var window:Vector2 = window_size
			var pos:Vector2 = Vector2(event.position)
			var global_mouse_pos:Vector2 = pos - Vector2(
				(window.x * 0.5) - cam_x,
				window.y * 0.5
			)
			active_timeline.move_highlight(global_mouse_pos)
		
		if Input.is_action_pressed(&"ui_pan") and scroll and camera:
			camera.position.x -= event.relative.x
			camera.position.x = clampf(camera.position.x, CAM_MIN_X, cam_max_x)


#func append_section(x_offset:float = 0.0, x_add_mod:float = 0.0) -> void:
#	var new_section:Section = Section.new()
#	new_section.id = EditorMain.section_data.size()
#	new_section.start_beat = EditorMain.total_section_beats
#	new_section.start_x = EditorMain.total_section_x + x_offset
#	EditorMain.section_data.append(new_section)
#	EditorMain.total_section_beats += new_section.beats
#	EditorMain.total_section_x += new_section.beats * x_add_mod


#func get_section_from_x(x:float) -> int:
#	var closest_i:int = 0
#	for i in range(EditorMain.section_data.size()):
#		if EditorMain.section_data[i].start_x < x:
#			closest_i = EditorMain.section_data[i].id
#	return closest_i
