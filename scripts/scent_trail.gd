extends Node

export (PackedScene) var packed_scent_trail

var is_trailing_scents : bool
var scent_trail_frames : int

var character
var root

var scent_trails := []

func _ready() -> void:
	character = get_parent() as Character
	root = get_parent().owner

	is_trailing_scents = true

func create_scent_trail() -> void:
	var new_scent_trail = packed_scent_trail.instance()

	root.add_child(new_scent_trail)
	scent_trails.push_front(new_scent_trail)
	new_scent_trail.position = character.position

func _physics_process(_delta: float) -> void:
	if scent_trails.size() > 30:
		scent_trails[scent_trails.size() - 1].queue_free()
		scent_trails.remove(scent_trails.size() - 1)

	if is_trailing_scents and character.velocity != Vector2():
		scent_trail_frames += 1
		if scent_trail_frames % 15 == 0:
			create_scent_trail()
			is_trailing_scents = false

	else:
		is_trailing_scents = true
