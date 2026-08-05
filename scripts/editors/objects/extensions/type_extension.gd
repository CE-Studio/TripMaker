class_name TypeExtension
extends Node


var e_obj:EditorObject
var g_obj:BeatObject

var edit_mode:bool = false


func save_to_string() -> PackedStringArray:
	return []

func _attribute_to_string(attribute:Statics.Attributes, value:Variant) -> String:
	var i:int = attribute as int
	return ":".join([str(i), str(value)])


func load_attribute(_attribute:Statics.Attributes, _value:Variant) -> void:
	pass
