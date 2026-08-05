class_name Widget
extends Node2D


#region Variables
const LERP_RATE:float = 10.0
const SELECT_EXTENSION:float = 64.0

@export var type_key:String = ""
var obj:EditorObject
var rest_dir:Vector2 = Vector2.RIGHT
var mode:int = -1
var color:Color = Color.WHITE

@export var button:TextureButton
@export var component:Node2D
#endregion


func _ready() -> void:
	modulate.a = 0.0
	button.disabled = true
	if component:
		component.modulate.a = 0.0


## Properly initializes this widget and its connection to its parent object
func instance(_obj:EditorObject, _rest_dir:Vector2) -> void:
	obj = _obj
	rest_dir = _rest_dir
	set_mode(0)


func _process(delta:float) -> void:
	queue_redraw()
	var this_delta:float = LERP_RATE * delta
	match mode:
		0:
			position = position.lerp(Vector2.ZERO, this_delta)
			modulate.a = lerp(modulate.a, 0.0, this_delta)
			if component: component.modulate.a = lerp(component.modulate.a, 0.0, this_delta)
		1:
			position = position.lerp(rest_dir * SELECT_EXTENSION, this_delta)
			modulate.a = lerp(modulate.a, 1.0, this_delta)
			if component: component.modulate.a = lerp(component.modulate.a, 0.0, this_delta)
		2:
			modulate.a = lerp(modulate.a, 1.0, this_delta)
			if component: component.modulate.a = lerp(component.modulate.a, 1.0, this_delta)
			_type_process(delta)
		_:
			return


## Unique process branch for different widget types to handle their own loops
func _type_process(_delta:float) -> void:
	pass


## Sets the widget's current select mode, controlling position, visibility, and button state
func set_mode(_mode:int) -> void:
	mode = _mode
	if _mode == 0:
		button.disabled = true
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		button.disabled = false
		button.mouse_filter = Control.MOUSE_FILTER_STOP


## Shortcut function that enables components
func _enable_control(ctrl:Control, value:Variant) -> void:
	ctrl.mouse_filter = Control.MOUSE_FILTER_STOP
	if ctrl is TextureButton:
		ctrl.button_pressed = bool(value)
	elif ctrl is HSlider or ctrl is VSlider:
		ctrl.value = float(value)
	elif ctrl is TextEdit:
		ctrl.text = str(value)

## Shortcut function that disables components
func _disable_control(ctrl:Control) -> void:
	ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE


## Returns the value of whatever object attribute this widget is set to configure
func return_target_value() -> Variant:
	return null


## Sets the value of the object attribute this widget is set to configure from an external call
func set_target_value(_value:Variant) -> void:
	pass


## Called when the widget's main button is pressed
func _on_button_pressed() -> void:
	if mode == 1:
		obj.update_widget_modes(0, self)
	elif mode == 2:
		obj.update_widget_modes(1)


func _draw() -> void:
	if not obj:
		return
	var direction = global_position.direction_to(obj.global_position)
	var offset:Vector2 = direction * 20.0
	draw_line(-position - offset, offset, Color(color.r, color.g, color.b, modulate.a), 2.0)
