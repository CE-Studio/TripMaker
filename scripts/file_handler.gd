class_name FileHandler
extends Node


#region Variables
const LEVEL_PATH:String = "user://levels/"
const LEVEL_EXT:String = ".btlvl"

var BASE_DICT:Dictionary = {
	&"name": "Untitled",
	&"author": "Unknown",
	&"game_ver": "0.1.0",
	&"bpm": 120.0,
	&"sections": [],
}
var SECTION_DICT:Dictionary = {
	&"id": 0,
	&"type": "beat",
	&"beats": []
}

var last_loaded_path:String = ""
var last_loaded_name:String = ""

static var instance:FileHandler
#endregion


func _ready() -> void:
	instance = self
	DirAccess.open(LEVEL_PATH)
	if DirAccess.get_open_error() != 0:
		DirAccess.make_dir_recursive_absolute(LEVEL_PATH)


func save_level_from_name(lvl_name:String, notes:Array[EditorObject]) -> void:
	var path:String = LEVEL_PATH + lvl_name + LEVEL_EXT
	save_level(path, notes)


func save_level(lvl_path:String, notes:Array[EditorObject]) -> void:
	var new_dict:Dictionary = BASE_DICT.duplicate()
	var new_section:Dictionary = SECTION_DICT.duplicate()
	for i in notes:
		#new_section[&"beats"].append("0:%s;1:%s;2:%s" % [i.beat, i.type, i.y])
		new_section[&"beats"].append(_beat_to_string(i))
	new_dict[&"sections"].append(new_section)
	
	var path_parts:PackedStringArray = lvl_path.split("/")
	var lvl_name:String = path_parts[path_parts.size() - 1]
	lvl_name = lvl_name.replace(LEVEL_EXT, "")
	new_dict[&"name"] = lvl_name
	var file := FileAccess.open(lvl_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(new_dict, "\t", false))
	file.close()
	_set_last_saved(lvl_path, lvl_name)


func load_level(lvl_path:String):
	var file:String = FileAccess.get_file_as_string(lvl_path)
	var data:Dictionary = JSON.parse_string(file)
	for section in data[&"sections"]:
		for beat in section[&"beats"]:
			EditorBeat.instance.place_loaded_obj(_string_to_beat(beat))
	_set_last_saved(lvl_path)
	Statics.editor_accepts_inputs = true


func _set_last_saved(lvl_path:String, lvl_name:String = "") -> void:
	last_loaded_path = lvl_path
	last_loaded_name = lvl_name
	if lvl_name == "":
		var path_parts:PackedStringArray = lvl_path.split("/")
		lvl_name = path_parts[path_parts.size() - 1]
		last_loaded_name = lvl_name.replace(LEVEL_EXT, "")
		print(last_loaded_name)
	EditorUI.instance.set_saved_label_text(lvl_name + LEVEL_EXT)


func level_exists_at_path(path:String) -> bool:
	return FileAccess.file_exists(path)


func level_exists_in_main_folder(lvl_name:String) -> bool:
	return level_exists_at_path(lvl_name.join([LEVEL_PATH, LEVEL_EXT]))


func _beat_to_string(note:EditorObject) -> String:
	var out_vals:PackedStringArray = []
	out_vals.append("0:" + str(note.beat))
	out_vals.append("1:" + str(note.type))
	out_vals.append("3:" + str(note.y))
	return ";".join(out_vals)


func _string_to_beat(string:String, type:int = 0) -> EditorObject:
	var obj:EditorObject
	match type:
		0: obj = load("res://scenes/editors/beat_editor_object.tscn").instantiate()
	var elements:PackedStringArray = string.split(";")
	for element in elements:
		var parts:PackedStringArray = element.split(":")
		var attribute_id:int = int(parts[0])
		var attribute_val:float = float(parts[1])
		match attribute_id:
			#region General
			0: # Object's home beat
				obj.beat = attribute_val
			1: # Object's type
				obj.type = roundi(attribute_val)
			2: # Object's X offset
				obj.x = attribute_val
			3: # Object's Y offset
				obj.y = attribute_val
			4: # Object's angle
				obj.angle = attribute_val
			5: # Object's speed
				obj.speed = attribute_val
			#endregion
			#region Beat
			#endregion
	return obj
