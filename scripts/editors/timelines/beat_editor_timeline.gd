class_name BeatTimeline
extends Node2D


#region Variables
#const ORIGIN:Vector2 = Vector2(0.0, 24.0)
#const GRID_HEIGHT:int = 16
#const GRID_SIZE:Vector2i = Vector2i(80, 28)
#const GRID_VERT_DIVISION:int = 4
#const SECTION_SIZE:int = 8
#const VISIBLE_SECTION_EXTENT:float = 1200.0

var visible_beats:Vector2i = Vector2i.ZERO
var mouse_in_bounds:bool = false

var half_height:float:
	get(): #return GRID_SIZE.y * GRID_HEIGHT * 0.5
		return editor.grid_scale.y * editor.vertical_divisions * 0.5

@export var editor:EditorBeat
#endregion


func _ready() -> void:
	assert(editor != null, "BEAT timeline must have a parent editor associated with it!")
	#if main_editor:
	#	for i in range(sections):
	#		main_editor.append_section(origin.x, GRID_SIZE.x)


func _process(_delta: float) -> void:
	if editor:
		var last_visible:Vector2i = visible_beats
		var cam_pos:float = editor.cam_x - editor.origin.x
		var x_scale:float = editor.grid_scale.x
		var _min:float = clampf(cam_pos - editor.visible_extents, 0.0, INF)
		visible_beats.x = floori(_min / x_scale)
		var _max:float = cam_pos + editor.visible_extents
		visible_beats.y = floori(_max / x_scale)
		if last_visible != visible_beats:
			queue_redraw()


func _draw() -> void:
	var start_x:float = editor.origin.x + (visible_beats.x * editor.grid_scale.x)
	var x_tiles:int = visible_beats.y - visible_beats.x
	var num_y:float = editor.origin.y
	
	# Draw horizontal lines
	for i in range(editor.vertical_divisions + 1):
		var this_y:float = editor.origin.y + (editor.grid_scale.y * i)
		var left:Vector2 = Vector2(start_x - (editor.GRID_BORDER_WIDTH * 0.5), this_y)
		var right:Vector2 = Vector2(start_x + (editor.grid_scale.x * x_tiles)
			+ (editor.GRID_BORDER_WIDTH * 0.5), this_y)
		var width:int = editor.GRID_WIDTH
		if i % editor.vertical_section_size == 0:
			width = editor.GRID_BORDER_WIDTH
		draw_line(left, right, editor.GRID_COLOR, width)
	
	# Draw vertical lines
	for i in range(x_tiles + 1):
		var this_x:float = start_x + (editor.grid_scale.x * i)
		var top:Vector2 = Vector2(this_x, editor.origin.y + (editor.GRID_BORDER_WIDTH * 0.5))
		var bottom:Vector2 = Vector2(this_x,
			editor.origin.y + (editor.vertical_divisions * editor.grid_scale.y)
			- (editor.GRID_BORDER_WIDTH * 0.5))
		var width:int = editor.GRID_WIDTH
		if (visible_beats.x + i) % editor.horizontal_section_size == 0:
			width = editor.GRID_BORDER_WIDTH
		draw_line(top, bottom, editor.GRID_COLOR, width)
	
	# Draw section numbers
	for i in range(visible_beats.x, visible_beats.y + 1):
		if i % editor.horizontal_section_size == 0:
			var this_x:float = (i * editor.grid_scale.x  + editor.origin.x)
			var this_num:String = str(i)
			if this_num != "0":
				draw_string(editor.default_font, Vector2(this_x, num_y), this_num,
					HORIZONTAL_ALIGNMENT_LEFT, -1, editor.SECTION_NUM_SIZE)


#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed(&"ui_mouse_left") and mouse_in_bounds:
#		if editor_obj and BuildPanel.selected_element >= 0:
#			var section:int = EditorScene.instance.get_section_from_x(highlighted_position.x)
#			place_obj(editor_obj, section, highlighted_position)
