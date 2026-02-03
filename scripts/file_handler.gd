class_name FileHandler
extends Node


#region Variables
const LEVEL_PATH:String = "user://levels/"
const LEVEL_EXT:String = ".btlvl"

const BASE_DICT:Dictionary = {
	&"name": "Untitled",
	&"author": "Unknown",
	&"game_ver": "0.1.0",
	&"sections": []
}
const SECTION_DICT:Dictionary = {
	&"id": 0,
	&"type": "beat",
	&"beats": []
}

var last_loaded_path:String = ""
#endregion


func _ready() -> void:
	DirAccess.open(LEVEL_PATH)
	if DirAccess.get_open_error() != 0:
		DirAccess.make_dir_recursive_absolute(LEVEL_PATH)


func save_level(lvl_name:String, notes:Array):
	var new_dict:Dictionary = BASE_DICT.duplicate()
	var new_section:Dictionary = SECTION_DICT.duplicate()
	for i in notes:
		new_section[&"beats"].append("0:%s;1:%s;2:%s" % [i.beat, i.type, i.y])
	new_dict[&"sections"].append(new_section)
	
	var file := FileAccess.open(LEVEL_PATH + lvl_name + LEVEL_EXT, FileAccess.READ_WRITE)
	file.store_string(JSON.stringify(new_dict, "\t", false))
	file.close()


func load_level(path:String):
	pass
