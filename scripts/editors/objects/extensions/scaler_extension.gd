class_name ScalerExtension
extends TypeExtension


var min_scale:float = 0.5
var max_scale:float = 4.0
var cycle_beat_dur:float = 2.0
var slim_scale:bool = false
var abs_cycle:bool = false

var elapsed:float = 0.0


func _process(delta:float) -> void:
	#region Edit process
	if edit_mode and e_obj:
		elapsed += delta * cycle_beat_dur
		var this_min:float = min_scale
		var this_max:float = max_scale
		if not e_obj.selected:
			this_min = lerpf(this_min, 1.0, 0.75)
			this_max = lerpf(this_max, 1.0, 0.75)
		var middle:float = (this_min + this_max) * 0.5
		var difference:float = this_max - middle
		var cycle:float = sin(elapsed * PI)
		if abs_cycle:
			cycle = abs(cycle)
		var this_scale:float = middle + (cycle * difference)
		e_obj.current_scale = Vector2(1.0 if slim_scale else this_scale, this_scale)
	#endregion
	#region Game process
	if not edit_mode and g_obj:
		var this_elapsed:float = g_obj.end_elapsed - GameMain.instance.elapsed
		this_elapsed *= PI * cycle_beat_dur
		var middle:float = (min_scale + max_scale) * 0.5
		var difference:float = max_scale - middle
		var cycle:float = sin(this_elapsed)
		if abs_cycle:
			cycle = abs(cycle)
		var this_scale:float = middle + (cycle * difference)
		g_obj.sprite.scale = Vector2(1.0 if slim_scale else this_scale, this_scale) * g_obj.BASE_SCALE
	#endregion


func save_to_string() -> PackedStringArray:
	var out_vals:PackedStringArray = []
	out_vals.append(_attribute_to_string(Statics.Attributes.SCALER_MIN, min_scale))
	out_vals.append(_attribute_to_string(Statics.Attributes.SCALER_MAX, max_scale))
	out_vals.append(_attribute_to_string(Statics.Attributes.SCALER_TIME, cycle_beat_dur))
	out_vals.append(_attribute_to_string(Statics.Attributes.SCALER_SLIM, slim_scale))
	out_vals.append(_attribute_to_string(Statics.Attributes.SCALER_ABS, abs_cycle))
	return out_vals


func load_attribute(_attribute:Statics.Attributes, _value:Variant) -> void:
	match _attribute:
		Statics.Attributes.SCALER_MIN: min_scale = float(_value)
		Statics.Attributes.SCALER_MAX: max_scale = float(_value)
		Statics.Attributes.SCALER_TIME: cycle_beat_dur = float(_value)
		Statics.Attributes.SCALER_SLIM: slim_scale = _value == "true"
		Statics.Attributes.SCALER_ABS: abs_cycle = _value == "true"
