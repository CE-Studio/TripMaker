extends PanelContainer


var default:String = "Level"
@export var field:TextEdit
@onready var file:FileHandler = EditorBeat.instance.file_handler


func _ready() -> void:
	if field:
		default = field.placeholder_text


func _on_save() -> void:
	var lvl_name:String = field.text
	if lvl_name.strip_edges() == "":
		lvl_name = default
	var exists:bool = file.level_exists_in_main_folder(lvl_name)
	if exists:
		var overwrite_panel:PanelContainer = load("uid://cwu7be5yb7i8g").instantiate()
		overwrite_panel.lvl_name = lvl_name
		EditorUI.instance.add_child(overwrite_panel)
	else:
		file.save_level(lvl_name, EditorBeat.instance.objects)
	_on_cancel()


func _on_cancel() -> void:
	Statics.editor_accepts_inputs = true
	queue_free()
