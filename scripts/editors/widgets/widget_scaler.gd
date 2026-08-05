class_name WidgetScaler
extends Widget


#region Variables
var ext:ScalerExtension

var text_edited_this_frame:bool = false

@export var slider_min:HSlider
@export var text_min:TextEdit
@export var slider_max:HSlider
@export var text_max:TextEdit
@export var slider_time:HSlider
@export var text_time:TextEdit
@export var button_slim:TextureButton
@export var button_abs:TextureButton
#endregion


func _ready() -> void:
	super()
	color = Statics.COLORS_TRANSITION[5]


func instance(_obj:EditorObject, _rest_dir:Vector2) -> void:
	super(_obj, _rest_dir)
	assert(obj.type_ext is ScalerExtension, "Mismatched extension found on Scaler beat")
	ext = obj.type_ext


func _type_process(_delta:float) -> void:
	text_edited_this_frame = false
	position = position.lerp(Vector2(-64, -64), LERP_RATE * _delta)


func set_mode(_mode:int) -> void:
	super(_mode)
	if mode == 2 and obj.type_ext is ScalerExtension:
		text_edited_this_frame = true
		_enable_control(slider_min, clampf(
			ext.min_scale, slider_min.min_value, slider_min.max_value))
		_enable_control(text_min, str(ext.min_scale))
		_enable_control(slider_max, clampf(
			ext.max_scale, slider_max.min_value, slider_max.max_value))
		_enable_control(text_max, str(ext.max_scale))
		_enable_control(slider_time, clampf(
			ext.cycle_beat_dur, slider_time.min_value, slider_time.max_value))
		_enable_control(text_time, str(ext.cycle_beat_dur))
		_enable_control(button_slim, ext.slim_scale)
		_enable_control(button_abs, ext.abs_cycle)
	else:
		_disable_control(slider_min)
		_disable_control(text_min)
		_disable_control(slider_max)
		_disable_control(text_max)
		_disable_control(slider_time)
		_disable_control(text_time)
		_disable_control(button_slim)
		_disable_control(button_abs)


func return_target_value() -> Variant:
	return [
		ext.min_scale,
		ext.max_scale,
		ext.cycle_beat_dur,
		ext.slim_scale,
		ext.abs_cycle
	]


func set_target_value(_value:Variant) -> void:
	text_edited_this_frame = true
	ext.min_scale = _value[0]
	ext.max_scale = _value[1]
	ext.cycle_beat_dur = _value[2]
	ext.slim_scale = _value[3]
	ext.abs_cycle = _value[4]


## Called when the minimum scale slider has its value adjusted
func _on_min_slider_changed(value:float) -> void:
	if not text_edited_this_frame:
		text_edited_this_frame = true
		ext.min_scale = value
		text_min.text = str(value)


## Called when the minimum scale text box has its text changed
func _on_min_text_changed() -> void:
	if text_edited_this_frame:
		return
	text_edited_this_frame = true
	if text_min.text.is_valid_float():
		var value:float = float(text_min.text)
		slider_min.value = value
		ext.min_scale = value


## Called when the maximum scale slider has its value adjusted
func _on_max_slider_changed(value:float) -> void:
	if not text_edited_this_frame:
		text_edited_this_frame = true
		ext.max_scale = value
		text_max.text = str(value)


## Called when the maximum scale text box has its text changed
func _on_max_text_changed() -> void:
	if text_edited_this_frame:
		return
	text_edited_this_frame = true
	if text_max.text.is_valid_float():
		var value:float = float(text_max.text)
		slider_max.value = value
		ext.max_scale = value


## Called when the cycle time slider has its value adjusted
func _on_time_slider_changed(value:float) -> void:
	if not text_edited_this_frame:
		text_edited_this_frame = true
		ext.cycle_beat_dur = value
		text_time.text = str(value)


## Called when the cycle time text box has its text changed
func _on_time_text_changed() -> void:
	if text_edited_this_frame:
		return
	text_edited_this_frame = true
	if text_time.text.is_valid_float():
		var value:float = float(text_time.text)
		slider_time.value = value
		ext.cycle_beat_dur = value


## Called when the absolute value cycle button is toggled
func _on_slim_toggled(on:bool) -> void:
	ext.slim_scale = on


## Called when the slim scale button is toggled
func _on_abs_toggled(on:bool) -> void:
	ext.abs_cycle = on


func _input(event: InputEvent) -> void:
	if mode != 2:
		return
	if event.is_action_pressed("ui_fine_control"):
		slider_min.step = 0.01
		slider_max.step = 0.01
		slider_time.step = 0.01
	elif event.is_action_released("ui_fine_control"):
		slider_min.step = 0.25
		slider_max.step = 0.25
		slider_time.step = 0.25
