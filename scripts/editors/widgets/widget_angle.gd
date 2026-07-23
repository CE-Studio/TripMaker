class_name WidgetAngle
extends Widget


#region Variables
const SET_ANGLES_TILE:Array[float] = [
	0.0,
	7.0250163,
	14.036243,
	18.434949,
	26.565051,
	36.869898,
	45.0,
	53.130102,
	63.434949,
	75.963757
]
const SET_ANGLES_CLEAN:Array[float] = [
	0.0,
	15.0,
	30.0,
	45.0,
	60.0,
	75.0
]
const HANDLE_RADIUS:float = 128.0

static var show_clean:bool = false
var current_angles:Array[float] = []
var elapsed:float = 0.0
var handle_grabbed:bool = false
var text_edited_this_frame:bool = false

@export var handle:TextureButton
@export var text:TextEdit
@export var cycle:TextureButton
#endregion


func _ready() -> void:
	super()
	color = Color("ffaa2b")
	setup_working_array()


func _type_process(delta:float) -> void:
	text_edited_this_frame = false
	position = position.lerp(Vector2(-32, -32), LERP_RATE * delta)
	elapsed += delta
	if handle_grabbed:
		text_edited_this_frame = true
		var mouse_pos:Vector2 = get_global_mouse_position() - obj.global_position
		mouse_pos /= obj.editor.grid_scale
		mouse_pos = mouse_pos.normalized()
		var angle:float = Vector2.RIGHT.angle_to(mouse_pos)
		if not Input.is_action_pressed("ui_fine_control"):
			var closest_i:int = -1
			var closest_angle:float = 9999.0
			for i in range(current_angles.size()):
				var diff:float = abs(angle_difference(angle, deg_to_rad(current_angles[i])))
				if diff < closest_angle:
					closest_angle = diff
					closest_i = i
			angle = current_angles[closest_i]
		else:
			angle = rad_to_deg(angle)
		obj.angle = angle
		text.text = str(obj.angle)
	_update_handle_position()


## Updates the position of the angle handle
func _update_handle_position() -> void:
	var origin:Vector2 = obj.global_position
	var angle:float = deg_to_rad(obj.angle)
	handle.global_position = origin + Vector2.RIGHT.rotated(angle) * obj.editor.grid_scale
	handle.global_position = origin + origin.direction_to(handle.global_position).normalized() * HANDLE_RADIUS
	handle.position -= handle.size * 0.5


func set_mode(_mode:int) -> void:
	super(_mode)
	if mode == 2:
		text_edited_this_frame = true
		handle.mouse_filter = Control.MOUSE_FILTER_STOP
		_update_handle_position()
		text.mouse_filter = Control.MOUSE_FILTER_STOP
		text.text = str(obj.angle)
		cycle.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		handle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cycle.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	super()
	if mode == 2 and component.modulate.a > 0.0:
		var col:Color = Color(color.r, color.g, color.b,
			component.modulate.a * 0.5 + (0.25 * sin(elapsed * 2.0)))
		var origin:Vector2 = obj.global_position - global_position
		for angle in current_angles:
			var rot_vector = Vector2.RIGHT.rotated(deg_to_rad(angle))
			var grid_scale:Vector2 = obj.editor.grid_scale
			var angle_vector:Vector2 = (rot_vector * grid_scale).normalized()
			draw_line(origin + angle_vector * 24, origin + angle_vector * 192, col, 2)
		col.a = 1.0
		var angle:float = 80.0 - (10.0 * obj.editor.h_zoom)
		draw_arc(origin, HANDLE_RADIUS, deg_to_rad(-angle), deg_to_rad(angle), 16, col, 3)


## Pulls a list of constant angles depending on the current cycle mode and runs them and their
## negative variants through the working array
func setup_working_array() -> void:
	current_angles.clear()
	var base:Array[float] = SET_ANGLES_CLEAN if show_clean else SET_ANGLES_TILE
	for i in range(base.size()):
		current_angles.append(base[i])
		if i != 0:
			current_angles.append(-base[i])


## Called when the mode cycle button is pressed
func _on_cycle_pressed() -> void:
	show_clean = not show_clean
	setup_working_array()


## Called when the handle button is pressed
func _on_handle_grabbed() -> void:
	handle_grabbed = true


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_mouse_left"):
		if handle_grabbed: handle_grabbed = false


## Called when the text box has its text changed
func _on_text_changed() -> void:
	if text_edited_this_frame:
		return
	text_edited_this_frame = true
	if text.text.is_valid_float():
		var value:float = float(text.text)
		value = clampf(value, -89.0, 89.0)
		obj.angle = value
