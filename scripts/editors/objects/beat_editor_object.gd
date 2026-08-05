class_name BeatEditorObject
extends EditorObject


#region Variables
const SCALE_MOD_NOMOUSE:float = 0.75
const SCALE_MOD_MOUSE:float = 1.0
const SCALE_MOD_LERP_RATE:float = 24.0

var current_scale:Vector2 = Vector2(0.75, 0.75)
var current_scale_mod:float = SCALE_MOD_NOMOUSE
#endregion


func _ready() -> void:
	if type == Statics.BeatObjs.NONE:
		type = Statics.BeatObjs.NORMAL
	
	sprite.scale = current_scale
	sprite.modulate = Statics.BEAT_DATA_DICT[type][1]
	super()


func _spawn_widgets() -> void:
	_create_single_widget("uid://hoaysujvnl43", Vector2.RIGHT)
	_create_single_widget("uid://6mhl26a5jlre", Vector2.UP)
	match type:
		Statics.BeatObjs.SCALER:
			_create_single_widget("uid://vn780u06mc73", Vector2.LEFT)


func _add_type_extension(_type:int = type) -> void:
	var ext:TypeExtension = null
	match _type as Statics.BeatObjs:
		Statics.BeatObjs.SCALER: ext = ScalerExtension.new()
	if ext:
		ext.edit_mode = true
		add_child(ext)
		type_ext = ext
		ext.e_obj = self


func _process(delta: float) -> void:
	super(delta)
	current_scale_mod = lerp(current_scale_mod,
	SCALE_MOD_MOUSE if mouse_over else SCALE_MOD_NOMOUSE, SCALE_MOD_LERP_RATE * delta)
	sprite.scale = current_scale * current_scale_mod
	
	if editor:
		position = Vector2(beat, y) * editor.grid_scale + editor.origin
