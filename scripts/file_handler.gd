class_name FileHandler
extends Node


#region Variables
const LEVEL_PATH:String = "user://levels/"
const LEVEL_EXT:String = ".btlvl"

var BASE_DICT:Dictionary = {
	&"name": "Untitled",
	&"author": "Unknown",
	&"game_ver": "0.1.0",
	&"sections": []
}
var SECTION_DICT:Dictionary = {
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
	
	new_dict[&"name"] = lvl_name
	var file := FileAccess.open(LEVEL_PATH + lvl_name + LEVEL_EXT, FileAccess.WRITE)
	file.store_string(JSON.stringify(new_dict, "\t", false))
	file.close()
	last_loaded_path = lvl_name
	EditorUI.instance.set_saved_label_text(lvl_name + LEVEL_EXT)


func load_level(_path:String):
	pass


func level_exists_at_path(path:String) -> bool:
	return FileAccess.file_exists(path)


func level_exists_in_main_folder(lvl_name:String) -> bool:
	return level_exists_at_path(lvl_name.join([LEVEL_PATH, LEVEL_EXT]))
