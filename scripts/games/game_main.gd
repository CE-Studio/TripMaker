class_name GameMain
extends Node2D


#region Variables
const SPAWN_BEATS:int = 4

var window_height:float
var elapsed:float = 0.0
var running_elapsed:float = 0.0
var current_beat:int = 0
var bpm:float = 120.0

@export var game_beat:GameBeat

signal beat(count:int)
#endregion


func _ready() -> void:
	window_height = get_viewport_rect().size.y
	assert(game_beat, "Main game scene is missing BEAT!")
	game_beat.main = self
	
	var beat_dur:float = 60.0 / bpm
	elapsed = beat_dur * -SPAWN_BEATS
	running_elapsed = elapsed


func _process(delta: float) -> void:
	elapsed += delta
	running_elapsed += delta
	var beat_dur:float = 60.0 / bpm
	while running_elapsed > beat_dur:
		running_elapsed -= beat_dur
		current_beat += 1
		beat.emit(current_beat)
