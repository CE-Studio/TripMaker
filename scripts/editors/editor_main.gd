class_name EditorMain
extends Control


#region Variables
var build_panel_visible:bool:
	get():
		if active_build_panel:
			return active_build_panel.panel_visible
		return false

static var instance:EditorMain

static var section_data:Array[Section]
static var total_section_beats:int = 0
static var total_section_x:float = 0.0

@export var active_build_panel:BuildPanel
@export var main_scene:EditorScene
#endregion


func _ready() -> void:
	instance = self
