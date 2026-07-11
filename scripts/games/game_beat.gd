class_name GameBeat
extends Node2D


#region Variables
const PADDLE_X:float = 49
const PADDLE_BOUNDS:float = 118.0

var main:GameMain

var ticks:int = 0
var objs:Array[BeatObject] = []

@export var paddle:Node2D
@export var debug:RichTextLabel
@export var beat_group:Node2D
@export var ui_score:RichTextLabel
@export var ui_mult:RichTextLabel

@onready var obj:PackedScene = preload("uid://bugi3siejci1")
#endregion


func instance(_main:GameMain) -> void:
	main = _main
	ticks = main.SPAWN_BEATS * main.TICKS_PER_BEAT * -1
	assert(paddle, "BEAT requires a paddle to be hooked up to work!")
	assert(beat_group, "BEAT requires an object parent to be hooked up to work!")
	for _obj in beat_group.get_children():
		if _obj is BeatObject:
			append_obj(_obj)


func tick(_delta:float, tick_count:int) -> void:
	for i in range(tick_count):
		ticks += 1
		for _obj in objs:
			_obj.tick(ticks)
	
	_update_debug_label()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		paddle.position = Vector2(PADDLE_X, event.position.y)
		paddle.position.y = clampf(paddle.position.y,
			PADDLE_BOUNDS, main.window_height - PADDLE_BOUNDS)


func update_ui() -> void:
	ui_score.text = "%010d" % [main.score]
	
	var combo:int = 100
	if main.combo >= 10: combo += main.combo
	ui_mult.text = "%04d x %04d" % [combo, main.mult]


func _update_debug_label() -> void:
	if not debug or not debug.visible:
		return
	var stats:PackedStringArray = []
	stats.append("%.4f" % main.elapsed)
	stats.append("BPM: " + str(main.bpm))
	stats.append("Beat: " + str(main.current_beat))
	stats.append("Ticks: " + str(ticks))
	stats.append("Active objects: " + str(main.obj_count))
	debug.text = "\n".join(stats)


func add_obj(attributes:Array) -> void:
	var new_obj:BeatObject = obj.instantiate()
	new_obj.target_pos = Vector2(float(attributes[0]), float(attributes[3]))
	new_obj.type = attributes[1]
	new_obj.speed = attributes[4]
	new_obj.angle = attributes[5]
	append_obj(new_obj)
	new_obj.tick(ticks)


func append_obj(_obj:BeatObject) -> void:
	beat_group.add_child(_obj)
	main.obj_count += 1
	_obj.game = self
	objs.append(_obj)
	_obj.hit.connect(main.on_beat_hit)
	_obj.despawn.connect(main.on_beat_missed)


func remove_obj(_obj:BeatObject) -> void:
	main.obj_count -= 1
	objs.remove_at(objs.find(_obj))
	_obj.queue_free()
