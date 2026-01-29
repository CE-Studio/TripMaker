@icon("uid://bk17y7r1bdydj")
class_name Section
extends RefCounted


enum GameStyles {
	BEAT,
	CORE,
	VOID,
	RUNNER,
	FATE
}

var id:int = 0
var beats:int = 8
var bpm:float = 132.0
var start_beat:int = 0
var start_x:float = 0.0
var style:GameStyles = GameStyles.BEAT
var objects:Array = []
