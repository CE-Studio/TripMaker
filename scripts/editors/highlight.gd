class_name Highlight
extends Node2D


#region Variables
const SPR_LERP_RATE:float = 24.0

var last_pos:Vector2

@onready var sprite:Sprite2D = $Sprite
@onready var body:StaticBody2D = $ClickBody

signal clicked_left
signal clicked_right
#endregion


func _process(delta: float) -> void:
	sprite.global_position = last_pos.lerp(global_position, SPR_LERP_RATE * delta)
	last_pos = sprite.global_position


func _on_click_body_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if not Statics.editor_accepts_inputs:
		return
	if _event.is_action_pressed("ui_mouse_left"):
		#print("Body clicked (left)")
		clicked_left.emit()
	elif _event.is_action_pressed("ui_mouse_right"):
		#print("Body clicked (right)")
		clicked_right.emit()
