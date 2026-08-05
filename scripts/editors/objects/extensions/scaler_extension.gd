class_name ScalerExtension
extends TypeExtension


var min_scale:float = 0.25
var max_scale:float = 1.5
var cycle_beat_dur:float = 2.0
var slim_scale:bool = false
var abs_cycle:bool = false

var elapsed:float = 0.0


func _process(delta:float) -> void:
	elapsed += delta
	var middle:float = (min_scale + max_scale) * 0.5
	var difference:float = max_scale - middle
	var cycle:float = sin(elapsed * cycle_beat_dur)
	if abs_cycle:
		cycle = abs(cycle)
	var this_scale = middle + (cycle * difference)
	obj.current_scale = Vector2(1.0 if slim_scale else this_scale, this_scale)


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
		Statics.Attributes.SCALER_SLIM: slim_scale = bool(_value)
		Statics.Attributes.SCALER_ABS: abs_cycle = bool(_value)
