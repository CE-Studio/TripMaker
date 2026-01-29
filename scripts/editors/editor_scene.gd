class_name EditorScene
extends Node2D


#region Variables
const CAM_MIN_X:float = 0.0

var cam_max_x:float = 2000.0

var cam_x:float:
	get():
		if camera:
			return camera.position.x
		return 0.0

@export var ui_main:Control
@export var active_timeline:EditorTimeline
@export var camera:Camera2D
#endregion


func _ready() -> void:
	if active_timeline:
		active_timeline.main_editor = self


func _input(event: InputEvent) -> void:
	var scroll:bool = active_timeline and active_timeline.sidescrolling
	
	if event is InputEventMouseMotion and Input.is_action_pressed(&"ui_pan"):
		if scroll and camera:
			camera.position.x -= event.relative.x
			camera.position.x = clampf(camera.position.x, CAM_MIN_X, cam_max_x)
