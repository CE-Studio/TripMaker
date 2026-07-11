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

var elapsed:float = 0.0
var selected:bool = false

@export var timeline:EditorTimeline
@export var sprite:Sprite2D
@export var click_area:Node2D
@export var select_highlight:Sprite2D
#endregion


func _process(delta: float) -> void:
	elapsed += delta
	if selected:
		select_highlight.modulate.a = 0.5 + (sin(elapsed * 6.0) * 0.25)
	else:
		select_highlight.modulate.a = 0.0
