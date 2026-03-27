class_name GameBeat
extends Node2D


#region Variables
const PADDLE_X:float = 49
const PADDLE_BOUNDS:float = 118.0

var main:GameMain

@export var paddle:Node2D
@export var debug:RichTextLabel
#endregion


func _ready() -> void:
	assert(paddle, "BEAT requires a paddle to be hooked up to work!")


func _process(_delta: float) -> void:
	_update_debug_label()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		paddle.position = Vector2(PADDLE_X, event.position.y)
		paddle.position.y = clampf(paddle.position.y,
			PADDLE_BOUNDS, main.window_height - PADDLE_BOUNDS)


func _update_debug_label() -> void:
	if not debug or not debug.visible:
		return
	var stats:PackedStringArray = []
	stats.append("%.4f" % main.elapsed)
	stats.append("BPM: " + str(main.bpm))
	stats.append("Beat: " + str(main.current_beat))
	stats.append("Active objects: 0 (0/0/0)")
	debug.text = "\n".join(stats)
