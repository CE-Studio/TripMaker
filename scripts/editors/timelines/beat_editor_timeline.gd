class_name BeatTimeline
extends EditorTimeline


#region Variables
const ORIGIN:Vector2 = Vector2(-400.0, 0.0)
const GRID_HEIGHT:int = 16
const GRID_SIZE:Vector2i = Vector2i(80, 28)
const GRID_VERT_DIVISION:int = 4
const SECTION_SIZE:int = 8
const VISIBLE_SECTION_EXTENT:float = 1200.0

var visible_sections:Vector2i = Vector2i.ZERO
#endregion


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if main_editor:
		var last_visible:Vector2i = visible_sections
		var cam_pos:float = main_editor.cam_x - ORIGIN.x
		var x_scale:float = float(GRID_SIZE.x) * float(SECTION_SIZE)
		var _min:float = clampf(cam_pos - VISIBLE_SECTION_EXTENT, 0.0, INF)
		visible_sections.x = floori(_min / x_scale)
		var _max:float = cam_pos + VISIBLE_SECTION_EXTENT
		visible_sections.y = floori(_max / x_scale)
		if last_visible != visible_sections:
			queue_redraw()


func _draw() -> void:
	var start_x:float = ORIGIN.x + (visible_sections.x * GRID_SIZE.x * SECTION_SIZE)
	var x_tiles:int = (visible_sections.y - visible_sections.x) * SECTION_SIZE
	var half_height:float = GRID_SIZE.y * GRID_HEIGHT * 0.5
	var num_y:float = ORIGIN.y - half_height
	
	# Draw horizontal lines
	for i in range(GRID_HEIGHT + 1):
		var this_y:float = ORIGIN.y - half_height + (GRID_SIZE.y * i)
		var left:Vector2 = Vector2(start_x, this_y)
		var right:Vector2 = Vector2(start_x + (GRID_SIZE.x * x_tiles), this_y)
		var width:int = GRID_WIDTH
		if i % GRID_VERT_DIVISION == 0:
			width = GRID_BORDER_WIDTH
		draw_line(left, right, GRID_COLOR, width)
	
	# Draw vertical lines
	for i in range(x_tiles + 1):
		var this_x:float = start_x + (GRID_SIZE.x * i)
		var top:Vector2 = Vector2(this_x, ORIGIN.y - half_height)
		var bottom:Vector2 = Vector2(this_x, ORIGIN.y + half_height)
		var width:int = GRID_WIDTH
		if i % SECTION_SIZE == 0:
			width = GRID_BORDER_WIDTH
		draw_line(top, bottom, GRID_COLOR, width)
	
	# Draw section numbers
	for i in range(visible_sections.x, visible_sections.y + 1):
		var this_x:float = i * GRID_SIZE.x * SECTION_SIZE + ORIGIN.x
		var this_num:String = str(i * SECTION_SIZE)
		if this_num != "0":
			draw_string(default_font, Vector2(this_x, num_y), this_num,
				HORIZONTAL_ALIGNMENT_LEFT, -1, SECTION_NUM_SIZE)
