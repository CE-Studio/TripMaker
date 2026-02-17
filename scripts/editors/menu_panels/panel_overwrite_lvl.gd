extends PanelContainer


var lvl_name:String = "Level"
@export var text:RichTextLabel
@onready var file:FileHandler = EditorBeat.instance.file_handler


func _ready() -> void:
	if text:
		text.text = text.text % (lvl_name + FileHandler.LEVEL_EXT)


func _on_yes() -> void:
	file.save_level(lvl_name, EditorBeat.instance.objects)
	queue_free()


func _on_no() -> void:
	EditorUI.instance.add_child(load("uid://e17vtq3wiqlh").instantiate())
	queue_free()
