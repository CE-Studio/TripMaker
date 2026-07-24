class_name EditorObject
extends Node2D


#region Variables
var section:int = 0
var beat:float = 0.0
var type:int = -1
var x:float = 0.0
var y:float = 0.0
var angle:float = 0.0
var speed:float = 4.0
var type_vars:Array = []

var elapsed:float = 0.0
var selected:bool = false
var mouse_over:bool = false
var editor:EditorBeat
var widgets:Array[Widget] = []
var widget_active:String = ""

@export var timeline:EditorTimeline
@export var sprite:Sprite2D
@export var click_area:Node2D
@export var select_highlight:Sprite2D
#endregion


func _ready() -> void:
	_spawn_widgets()


func _spawn_widgets() -> void:
	pass

func _create_single_widget(uid:String) -> Widget:
	var widget:Widget = load(uid).instantiate()
	add_child(widget)
	widgets.append(widget)
	return widget


func _process(delta: float) -> void:
	elapsed += delta
	if selected:
		select_highlight.modulate.a = 0.5 + (sin(elapsed * 6.0) * 0.25)
	else:
		select_highlight.modulate.a = 0.0


func _on_click_body_mouse_entered() -> void:
	mouse_over = true


func _on_click_body_mouse_exited() -> void:
	mouse_over = false


func _on_click_body_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if not Statics.editor_accepts_inputs:
		return
	if _event.is_action_pressed("ui_mouse_left"):
		if not selected:
			editor.select_obj(self)
		elif selected:
			editor.deselect_obj(self)


func update_widget_modes(_mode:int, _selected:Widget = null) -> void:
	widget_active = ""
	for widget in widgets:
		if _mode == 0 and widget == _selected:
			widget.set_mode(2)
			widget_active = widget.type_key
		else:
			widget.set_mode(clampi(_mode, 0, 2))


func enable_widget_of_type(_type:String) -> void:
	var widget:Widget = null
	for _widget in widgets:
		if _widget.type_key == _type:
			widget = _widget
	if widget != null:
		update_widget_modes(0, widget)
