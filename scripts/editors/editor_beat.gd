class_name EditorBeat
extends Node2D


#region Variables
const GRID_COLOR:Color = Color(1.0, 1.0, 1.0, 0.4)
const GRID_WIDTH:int = 4
const GRID_BORDER_WIDTH:int = 8
const TEXT_COLOR:Color = Color(1.0, 1.0, 1.0, 0.75)
const SECTION_NUM_SIZE:int = 64
const BEAT_NUM_SIZE:int = 20
const H_SCALE_BASE:int = 28
const H_SCALE_ADD:int = 26
const MAX_ZOOM:int = 3

static var instance:EditorBeat

var origin:Vector2 = Vector2(0.0, -200.0)
var grid_scale:Vector2 = Vector2(80.0, 28.0)
var grid_subdivs:Vector2 = Vector2(0.5, 1.0)
var vertical_divisions:int = 16
var vertical_section_size:int = 4
var horizontal_section_size:int = 8
var visible_extents:float = 800.0
var default_font:Font = ThemeDB.fallback_font
var cam_min_x:float = 0.0
var cam_max_x:float = 4000.0
var h_zoom:int = 2

var cam_x:float:
	get():
		if camera:
			return camera.position.x
		return 0.0
var cam_y:float:
	get():
		if camera:
			return camera.position.y
		return 0.0
var window_size:Vector2i:
	get():
		return get_viewport_rect().size

var global_mouse_position:Vector2 = Vector2.ZERO
var highlighted_position:Vector2 = Vector2.ZERO
var mouse_in_bounds:bool = false

var objects:Array[EditorObject] = []
var last_selected_object:EditorObject = null
var last_found_i:int = -1

@export var file_handler:FileHandler
@export var highlight:Highlight
@export var camera:Camera2D
@export var ui:EditorUI
@export var beat_group:Node2D
@export var beat_object:PackedScene

signal edit_made
signal object_placed
signal object_removed
signal zoom_changed
#endregion


func _ready() -> void:
	instance = self
	if highlight:
		highlight.connect("clicked_left", place_obj)
		highlight.connect("clicked_right", remove_obj)
	assert(file_handler, "Editor scene requires a FileHandler node")


func move_highlight(new_pos:Vector2) -> void:
	mouse_in_bounds = false
	if new_pos.x >= 0.0 and new_pos.y >= 0.0 and new_pos.y <= vertical_divisions:
		mouse_in_bounds = true
	highlight.position = Vector2(
		clampf(highlighted_position.x, 0.0, INF),
		clampf(highlighted_position.y, 0.0, vertical_divisions)
	) * grid_scale + origin


func _input(event: InputEvent) -> void:
	if not Statics.editor_accepts_inputs:
		return
	if event is InputEventMouseMotion:
		var window:Vector2 = window_size
		var pos:Vector2 = Vector2(event.position)
		global_mouse_position = pos - Vector2(
			(window.x * 0.5) - cam_x + origin.x,
			(window.y * 0.5) - cam_y + origin.y
		)
		var scale_factors:Vector2 = Vector2(
			grid_scale.x * grid_subdivs.x,
			grid_scale.y * grid_subdivs.y
		)
		highlighted_position = Vector2(
			roundi(global_mouse_position.x / scale_factors.x) * grid_subdivs.x,
			roundi(global_mouse_position.y / scale_factors.y) * grid_subdivs.y,
		)
		move_highlight(highlighted_position)
	
		if Input.is_action_pressed(&"ui_pan") and camera:
			camera.position.x -= event.relative.x
			camera.position.x = clampf(camera.position.x, cam_min_x, cam_max_x)


func place_obj(pos:Vector2 = highlighted_position, type = BuildPanel.selected_element) -> void:
	if not Statics.editor_accepts_inputs or not mouse_in_bounds:
		return
	if type != Statics.BeatObjs.NONE and not check_position_occupied(pos):
		var last_widget:String = ""
		var last_obj:EditorObject = null
		if last_selected_object and last_selected_object.selected:
			last_widget = last_selected_object.widget_active
			last_obj = last_selected_object
		deselect_obj()
		var new_obj:BeatEditorObject = beat_object.instantiate()
		new_obj.editor = self
		new_obj.type = type as Statics.BeatObjs
		new_obj.beat = pos.x
		new_obj.y = pos.y
		beat_group.add_child(new_obj)
		new_obj._process(0.0)
		objects.append(new_obj)
		#print("Placed new object of type %s at %s" % [type, pos])
		edit_made.emit()
		object_placed.emit()
		if last_obj and last_obj.type == new_obj.type:
			for i in last_obj.widgets.size():
				new_obj.widgets[i].set_target_value(last_obj.widgets[i].return_target_value())
		if last_widget != "":
			select_obj(new_obj)
			new_obj.enable_widget_of_type(last_widget)


func place_loaded_obj(obj:EditorObject) -> void:
	if obj is BeatEditorObject:
		obj.editor = self
	beat_group.add_child(obj)
	obj._process(0.0)
	objects.append(obj)
	object_placed.emit()


func remove_obj(pos:Vector2 = highlighted_position) -> void:
	if not Statics.editor_accepts_inputs or not mouse_in_bounds:
		return
	var obj:BeatEditorObject = check_position_occupied(pos)
	if obj:
		if obj.selected:
			deselect_obj(obj)
		objects.remove_at(last_found_i)
		obj.queue_free()
		edit_made.emit()
		object_removed.emit()


func select_obj(obj:EditorObject) -> void:
	var last_widget:String = ""
	if last_selected_object and last_selected_object.selected:
		last_widget = last_selected_object.widget_active
		deselect_obj(last_selected_object)
	obj.selected = true
	if last_widget != "":
		obj.enable_widget_of_type(last_widget)
	else:
		obj.update_widget_modes(1)
	last_selected_object = obj


func deselect_obj(obj:EditorObject = last_selected_object) -> void:
	if obj:
		obj.selected = false
		obj.update_widget_modes(0)


#func update_cam_max() -> void:
#	cam_max_x = GRID_SIZE.x * sections * SECTION_SIZE + (ORIGIN.x * 2)


func check_position_occupied(pos:Vector2) -> BeatEditorObject:
	var out_obj:BeatEditorObject = null
	var i:int = 0
	while i < objects.size() and out_obj == null:
		var this_obj = objects[i]
		if Vector2(this_obj.beat, this_obj.y) == pos:
			out_obj = this_obj
			last_found_i = i
		i += 1
	return out_obj


func reset_all() -> void:
	for i in objects:
		i.queue_free()
	objects.clear()
	file_handler.last_loaded_path = ""
	file_handler.last_loaded_name = ""
	ui.set_saved_label_text("")


func increase_zoom() -> void:
	if h_zoom < MAX_ZOOM:
		h_zoom += 1
		update_zoom(true)

func decrease_zoom() -> void:
	if h_zoom > 0:
		h_zoom -= 1
		update_zoom(false)

func update_zoom(zoom_in:bool) -> void:
	grid_scale.x = H_SCALE_BASE + (H_SCALE_ADD * h_zoom)
	if zoom_in:
		camera.position.x /= H_SCALE_BASE + H_SCALE_ADD * (h_zoom - 1)
		camera.position.x *= H_SCALE_BASE + H_SCALE_ADD * h_zoom
	else:
		camera.position.x /= H_SCALE_BASE + H_SCALE_ADD * (h_zoom + 1)
		camera.position.x *= H_SCALE_BASE + H_SCALE_ADD * h_zoom
	camera.position.x = clampf(camera.position.x, 0.0, cam_max_x)
	zoom_changed.emit()
