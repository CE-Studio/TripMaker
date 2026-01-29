class_name EditorObject
extends Node2D


#region Variables
var section:int = 0
var beat:float = 0.0

var elapsed:float = 0.0

@export var timeline:EditorTimeline
@export var sprite:Sprite2D
@export var click_area:Node2D
#endregion


func _process(delta: float) -> void:
	elapsed += delta
