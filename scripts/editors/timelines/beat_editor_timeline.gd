class_name BeatTimeline
extends EditorTimeline


#region Variables
const ORIGIN:Vector2 = Vector2(-400.0, 24.0)
const GRID_HEIGHT:int = 16
const GRID_SIZE:Vector2i = Vector2i(80, 28)
const GRID_VERT_DIVISION:int = 4
const SECTION_SIZE:int = 8
const VISIBLE_SECTION_EXTENT:float = 1200.0

var visible_sections:Vector2i = Vector2i.ZERO
var mouse_in_bounds:bool = false

var half_height:float:
	get(): return GRID_SIZE.y * GRID_HEIGHT * 0.5

@export var editor_obj:PackedScene
#endregion


func _ready() -> void:
	origin = ORIGIN
	update_cam_max()
	if main_editor:
		for i in range(sections):
			main_editor.append_section(origin.x, GRID_SIZE.x)


func _process(_delta: float) -> void:
	if main_editor:
		var last_visible:Vector2i = visible_sections
		var cam_pos:float = main_editor.cam_x - origin.x
		var x_scale:float = float(GRID_SIZE.x) * float(SECTION_SIZE)
		var _min:float = clampf(cam_pos - VISIBLE_SECTION_EXTENT, 0.0, INF)
		visible_sections.x = floori(_min / x_scale)
		var _max:float = cam_pos + VISIBLE_SECTION_EXTENT
		visible_sections.y = clampi(floori(_max / x_scale), 0, sections)
		if last_visible != visible_sections:
			queue_redraw()


func _draw() -> void:
	var start_x:float = origin.x + (visible_sections.x * GRID_SIZE.x * SECTION_SIZE)
	var x_tiles:int = (visible_sections.y - visible_sections.x) * SECTION_SIZE
	var num_y:float = origin.y - half_height
	
	# Draw horizontal lines
	for i in range(GRID_HEIGHT + 1):
		var this_y:float = origin.y - half_height + (GRID_SIZE.y * i)
		var left:Vector2 = Vector2(start_x, this_y)
		var right:Vector2 = Vector2(start_x + (GRID_SIZE.x * x_tiles), this_y)
		var width:int = GRID_WIDTH
		if i % GRID_VERT_DIVISION == 0:
			width = GRID_BORDER_WIDTH
		draw_line(left, right, GRID_COLOR, width)
	
	# Draw vertical lines
	for i in range(x_tiles + 1):
		var this_x:float = start_x + (GRID_SIZE.x * i)
		var top:Vector2 = Vector2(this_x, origin.y - half_height)
		var bottom:Vector2 = Vector2(this_x, origin.y + half_height)
		var width:int = GRID_WIDTH
		if i % SECTION_SIZE == 0:
			width = GRID_BORDER_WIDTH
		draw_line(top, bottom, GRID_COLOR, width)
	
	# Draw section numbers
	for i in range(visible_sections.x, visible_sections.y + 1):
		var this_x:float = i * GRID_SIZE.x * SECTION_SIZE + origin.x
		var this_num:String = str(i * SECTION_SIZE)
		if this_num != "0":
			draw_string(default_font, Vector2(this_x, num_y), this_num,
				HORIZONTAL_ALIGNMENT_LEFT, -1, SECTION_NUM_SIZE)


#func _on_highlight_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_mouse_left") and mouse_in_bounds:
		if editor_obj and BuildPanel.selected_element >= 0:
			var section:int = EditorScene.instance.get_section_from_x(highlighted_position.x)
			place_obj(editor_obj, section, highlighted_position)


func move_highlight(new_pos:Vector2) -> void:
	if new_pos.x >= origin.x and abs(new_pos.y - origin.y) <= half_height:
		new_pos -= origin
		new_pos = Vector2(
			roundi(new_pos.x / (GRID_SIZE.x * 0.5)) * (GRID_SIZE.x * 0.5),
			roundi(new_pos.y / GRID_SIZE.y) * GRID_SIZE.y
		)
		new_pos += origin
		super(new_pos)
		mouse_in_bounds = true
	else:
		mouse_in_bounds = false


func update_cam_max() -> void:
	if main_editor:
		main_editor.cam_max_x = GRID_SIZE.x * sections * SECTION_SIZE + (ORIGIN.x * 2)
