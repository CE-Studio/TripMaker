class_name BeatEditorObject
extends EditorObject


#region Variables
const SCALE_MOD_NOMOUSE:float = 0.75
const SCALE_MOD_MOUSE:float = 1.0
const SCALE_MOD_LERP_RATE:float = 24.0

var mouse_over:bool = false
var current_scale:Vector2 = Vector2(0.75, 0.75)
var current_scale_mod:float = SCALE_MOD_NOMOUSE

var editor:EditorBeat
#endregion


func _ready() -> void:
	if type == Statics.BeatObjs.NONE:
		type = Statics.BeatObjs.NORMAL
	
	sprite.scale = current_scale
	sprite.modulate = Statics.BEAT_DATA_DICT[type][1]


func _process(delta: float) -> void:
	super(delta)
	if type == Statics.BeatObjs.SCALER:
		var this_scale = 0.75 + (sin(elapsed * 6.0) * 0.4)
		current_scale = Vector2(this_scale, this_scale)
	elif type == Statics.BeatObjs.INVIS:
		var this_a = 0.5 if floori(elapsed * 2) % 2 == 1 else 1.0
		sprite.modulate.a = this_a
	else:
		sprite.scale = Vector2.ONE
	current_scale_mod = lerp(current_scale_mod,
	SCALE_MOD_MOUSE if mouse_over else SCALE_MOD_NOMOUSE, SCALE_MOD_LERP_RATE * delta)
	sprite.scale = current_scale * current_scale_mod
	
	if editor:
		position = Vector2(beat, y) * editor.grid_scale + editor.origin


func _on_click_body_mouse_entered() -> void:
	mouse_over = true


func _on_click_body_mouse_exited() -> void:
	mouse_over = false


func _on_click_body_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if not Statics.editor_accepts_inputs:
		return
	if not selected and _event.is_action_pressed("ui_mouse_left"):
		editor.select_obj(self)
