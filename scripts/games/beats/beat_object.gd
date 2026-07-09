class_name BeatObject
extends Area2D


#region Variables
const START_X:float = 1164.0
const END_X:float = 58.0
const VERT_BOUNDS:float = 100.0

var game:GameBeat
var elapsed:float = 0.0
var viewport_height:float = 0.0
var beat_time:float = 0.5
var start_elapsed:float = 0.0
var end_elapsed:float = 0.0
var target_tick:int = 0
var start_tick:int = 0
var end_tick:int = 0
var target_y:float = 0.0
var y_area:float = 0.0
var flag_hit:bool = false
var flag_intersecting:bool = false

@export var target_pos:Vector2 = Vector2.ZERO
@export var speed:float = 4.0
@export var angle:float = 0.0
@export var type:Statics.BeatObjs = Statics.BeatObjs.NORMAL

@onready var sprite:Sprite2D = $Sprite2D

signal hit(points:int, add_combo:bool)
signal missed
signal despawn
#endregion


func _ready() -> void:
	spawn()


func spawn() -> void:
	viewport_height = get_viewport_rect().size.y
	y_area = viewport_height - (VERT_BOUNDS * 2.0)
	sprite.modulate = Statics.BEAT_DATA_DICT[type][1]
	
	end_elapsed = target_pos.x * beat_time
	start_elapsed = end_elapsed - beat_time * speed
	target_tick = roundi(end_elapsed * GameMain.TICKS_PER_BEAT) * 2
	end_tick = roundi(target_pos.x * GameMain.TICKS_PER_BEAT)
	start_tick = end_tick - roundi(GameMain.TICKS_PER_BEAT * speed)
	
	var y_prog:float = inverse_lerp(0.0, 16.0, target_pos.y)
	target_y = lerp(VERT_BOUNDS, viewport_height - VERT_BOUNDS, y_prog)


func _process(delta:float) -> void:
	elapsed += delta


func tick(this_tick:int) -> void:
	var progress:float = inverse_lerp(start_tick, end_tick, this_tick)
	if not flag_hit:
		position.x = lerp(START_X, END_X, progress)
	else:
		position.x = lerp(END_X, START_X, progress - 1.0)
	position.y = (position.x - END_X) * angle + target_y
	var times_flipped:int = 0
	while position.y < VERT_BOUNDS:
		position.y += y_area
		times_flipped += 1
	while position.y > viewport_height - VERT_BOUNDS:
		position.y -= y_area
		times_flipped += 1
	if times_flipped % 2 == 1:
		position.y = -(position.y - viewport_height)
	
	if this_tick >= target_tick and flag_intersecting:
		print("Hit on tick " + str(this_tick))
		flag_hit = true
		monitoring = false
		angle *= -1.0
		hit.emit(game.main.BASE_PTS, true)
	
	if position.x <= 0.0 and not flag_hit:
		print("Missed")
		missed.emit()
		game.remove_obj(self)
	elif (position.x <= 0.0 or position.x > START_X) and flag_hit:
		print("Despawned")
		despawn.emit()
		game.remove_obj(self)


func _on_hit_paddle() -> void:
	flag_hit = true
	hit.emit()


func _on_enter_paddle(_area:Area2D) -> void:
	flag_intersecting = true

func _on_exit_paddle(_area:Area2D) -> void:
	flag_intersecting = false
