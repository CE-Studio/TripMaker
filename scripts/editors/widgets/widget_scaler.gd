class_name WidgetScaler
extends Widget


#region Variables
var text_edited_this_frame:bool = false

@export var slider:HSlider
@export var text:TextEdit
#endregion


func _ready() -> void:
	super()
	color = Statics.COLORS_TRANSITION[5]


func _type_process(_delta:float) -> void:
	text_edited_this_frame = false
	position = position.lerp(Vector2(32, -32), LERP_RATE * _delta)


func set_mode(_mode:int) -> void:
	super(_mode)
	if mode == 2:
		text_edited_this_frame = true
		slider.mouse_filter = Control.MOUSE_FILTER_STOP
		slider.value = clampf(obj.speed, slider.min_value, slider.max_value)
		text.mouse_filter = Control.MOUSE_FILTER_STOP
		text.text = str(obj.speed)
	else:
		slider.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text.mouse_filter = Control.MOUSE_FILTER_IGNORE


func return_target_value() -> Variant:
	return obj.speed


func set_target_value(_value:Variant) -> void:
	text_edited_this_frame = true
	obj.speed = _value
	text.text = str(obj.speed)


## Called when the slider has its value adjusted
func _on_slider_changed(value:float) -> void:
	if not text_edited_this_frame:
		text_edited_this_frame = true
		obj.speed = value
		text.text = str(value)


## Called when the text box has its text changed
func _on_text_changed() -> void:
	if text_edited_this_frame:
		return
	text_edited_this_frame = true
	if text.text.is_valid_float():
		var value:float = float(text.text)
		value = clampf(value, 0.01, INF)
		slider.value = value
		obj.speed = value


func _input(event: InputEvent) -> void:
	if mode != 2:
		return
	if event.is_action_pressed("ui_fine_control"):
		slider.step = 0.01
	elif event.is_action_released("ui_fine_control"):
		slider.step = 0.25
