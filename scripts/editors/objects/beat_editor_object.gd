class_name BeatEditorObject
extends EditorObject


#region Variables
var type:Statics.BeatObjs = Statics.BeatObjs.NONE
var y:float = 0.0
var angle:float = 0.0
#endregion


func _ready() -> void:
	sprite.scale = Vector2(0.75, 0.75)
	sprite.modulate = Statics.BEAT_DATA_DICT[type][1]


func _process(delta: float) -> void:
	super(delta)
	if type == Statics.BeatObjs.SCALER:
		var this_scale = 0.75 + (sin(elapsed * 6.0) * 0.4)
		sprite.scale = Vector2(this_scale, this_scale)
	elif type == Statics.BeatObjs.INVIS:
		var this_a = 0.5 if floori(elapsed * 2) % 2 == 1 else 1.0
		sprite.modulate.a = this_a
