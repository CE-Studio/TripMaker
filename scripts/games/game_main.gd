class_name GameMain
extends Node2D


#region Variables
const SPAWN_BEATS:int = 1
const BASE_PTS:int = 100
const TICKS_PER_BEAT:float = 32.0

var window_height:float
var elapsed:float = 0.0
var running_elapsed:float = 0.0
var current_beat:int = 0
var bpm:float = 120.0
var obj_count:int = 0
var tick_time:float = 0.0

var hits:int = 0
var misses:int = 0
var score:int = 0
var combo:int = 0
var mult:int = 1

static var instance:GameMain

@export var game_beat:GameBeat

signal beat(count:int)
#endregion


func _ready() -> void:
	instance = self
	window_height = get_viewport_rect().size.y
	
	var beat_dur:float = 60.0 / bpm
	elapsed = beat_dur * -SPAWN_BEATS
	running_elapsed = elapsed
	
	assert(game_beat, "Main game scene is missing BEAT!")
	game_beat.instance(self)


func _process(delta: float) -> void:
	#delta *= 0.5
	elapsed += delta
	running_elapsed += delta
	
	var tick_dur:float = (60.0 / bpm) / TICKS_PER_BEAT
	tick_time += delta
	var current_tick_count:int = 0
	while tick_time > tick_dur:
		tick_time -= tick_dur
		current_tick_count += 1
	game_beat.tick(delta, current_tick_count)
	
	var beat_dur:float = 60.0 / bpm
	while running_elapsed > beat_dur:
		running_elapsed -= beat_dur
		current_beat += 1
		beat.emit(current_beat)


func on_beat_hit(points:int, add_combo:bool) -> void:
	hits += 1
	combo += 1
	if add_combo and combo >= 10:
		points += combo
	score += points * mult
	game_beat.update_ui()


func on_beat_missed() -> void:
	misses += 1
	combo = 0
