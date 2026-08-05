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
var type_ext:TypeExtension

@export var timeline:EditorTimeline
@export var sprite:Sprite2D
@export var click_area:Node2D
@export var select_highlight:Sprite2D
#endregion


func _ready() -> void:
	_spawn_widgets()


func _spawn_widgets() -> void:
	pass

func _create_single_widget(uid:String, rest_dir:Vector2) -> Widget:
	var widget:Widget = load(uid).instantiate()
	add_child(widget)
	widgets.append(widget)
	widget.instance(self, rest_dir)
	return widget


func _add_type_extension(_type:int = type) -> void:
	pass


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


func save_to_string() -> String:
	var out_vals:PackedStringArray = []
	out_vals.append(_attribute_to_string(Statics.Attributes.BEAT, beat))
	out_vals.append(_attribute_to_string(Statics.Attributes.TYPE, type))
	# 2 - x
	out_vals.append(_attribute_to_string(Statics.Attributes.Y, y))
	out_vals.append(_attribute_to_string(Statics.Attributes.SPEED, speed))
	out_vals.append(_attribute_to_string(Statics.Attributes.ANGLE, angle))
	if type_ext:
		out_vals.append_array(type_ext.save_to_string())
	return ";".join(out_vals)

func _attribute_to_string(attribute:Statics.Attributes, value:Variant) -> String:
	var i:int = attribute as int
	return ":".join([str(i), str(value)])


func load_from_string(attrs:PackedStringArray) -> void:
	for element in attrs:
		var parts:PackedStringArray = element.split(":")
		var attribute_id:int = int(parts[0])
		var attribute_val:Variant = parts[1]
		match attribute_id:
			Statics.Attributes.BEAT: # Object's home beat
				beat = float(attribute_val)
			Statics.Attributes.TYPE: # Object's type
				type = int(attribute_val)
				_add_type_extension()
			Statics.Attributes.X: # Object's X offset
				x = float(attribute_val)
			Statics.Attributes.Y: # Object's Y offset
				y = float(attribute_val)
			Statics.Attributes.SPEED: # Object's speed
				speed = float(attribute_val)
			Statics.Attributes.ANGLE: # Object's angle
				angle = float(attribute_val)
			_:
				if type_ext: type_ext.load_attribute(attribute_id, attribute_val)
