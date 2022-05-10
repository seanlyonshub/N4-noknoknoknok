extends Character
class_name Player

onready var scent_trail = get_node("scent_trail")

func get_input_x() -> float:
	var input_x : float

	var input_l := Input.get_action_strength("left")
	var input_r := Input.get_action_strength("right")

	if input_l != 0 and input_r != 0:
		input_x = direction.x

	else:
		input_x = input_r - input_l

	return input_x

func get_input_y() -> float:
	var input_y : float

	var input_u := Input.get_action_strength("up")
	var input_d := Input.get_action_strength("down")

	if input_u != 0 and input_d != 0:
		input_y = direction.y

	else:
		input_y = input_d - input_u

	return input_y

func get_real_mouse_position() -> Vector2:
	var viewport_size = get_viewport().size
	var viewport_origin = get_viewport().canvas_transform.origin
	var zoom = root.camera.zoom
	var ratio = OS.get_window_size() / viewport_size

	var viewport_mouse_position = get_viewport().get_mouse_position()
	var real_mouse_position = ((viewport_mouse_position / ratio) - viewport_origin) * zoom
	return real_mouse_position

func _physics_process(_delta: float) -> void:
	ray.cast_to = get_real_mouse_position() - position
	fists.look_at(get_real_mouse_position())

	if Input.is_action_just_pressed("attack"):
		attack()

	if Input.is_action_just_pressed("grab"):
		if weapon != null:
			throw()

		else:
			grab()
