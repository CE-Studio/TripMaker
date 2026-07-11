class_name GameMain
extends Node2D


#region Variables
const SPAWN_BEATS:int = 4
const BASE_PTS:int = 100
const TICKS_PER_BEAT:int = 32
const BEAT_LOOKAHEAD:int = 8

var window_height:float
var process:bool = true
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

var level_data:Dictionary = { }
var note_ptrs:Array[int] = [ 0, 0, 0, 0, 0 ]
var note_info_beat:Array[String] = [ ]
var next_obj_beat:Array = [ ]
var placed_all:Array[bool] = [ false, false, false, false, false ]

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
	
	beat.connect(on_beat)
	
	load_level_data()
	process_next_note_beat()
	check_add_next_beat()


func load_level_data() -> void:
	var path:String = Statics.level_load_path
	if path != "":
		var file:String = FileAccess.get_file_as_string(path)
		level_data = JSON.parse_string(file)
		bpm = level_data["bpm"]
		
		for section in level_data["sections"]:
			if section["type"] == "beat":
				for note in section["beats"]: note_info_beat.append(note)
		note_info_beat.sort_custom(func(a, b): return a.naturalnocasecmp_to(b) < 0)


func _process(delta: float) -> void:
	if process:
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


func on_beat(_beat_i:int) -> void:
	if not placed_all[0]:
		check_add_next_beat()


#region Note processing
func process_next_note_beat() -> bool:
	next_obj_beat.clear()
	if note_ptrs[0] >= note_info_beat.size():
		return false
	var note_str:String = note_info_beat[note_ptrs[0]]
	var attribute_strs:PackedStringArray = note_str.split(";")
	for attr in attribute_strs:
		var parts:PackedStringArray = attr.split(":")
		var id:int = int(parts[0])
		var value:Variant = parts[1]
		while next_obj_beat.size() < id: next_obj_beat.append(null)
		next_obj_beat.append(value)
	return true


func check_add_next_beat() -> void:
	while next_obj_beat.size() > 0 and int(next_obj_beat[0]) <= current_beat + BEAT_LOOKAHEAD:
		#print(next_obj_beat)
		game_beat.add_obj(next_obj_beat)
		note_ptrs[0] += 1
		process_next_note_beat()
#endregion
