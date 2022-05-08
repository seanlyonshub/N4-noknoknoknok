extends Node
class_name StateMachine

export (String) var states_folder
var state

func _ready() -> void:
	generate_states()

func generate_states() -> void:
	if states_folder != "":
		var states = get_scripts_in_folder(states_folder)

		for script in states:
			var new_script = load(script).new()
			add_child(new_script)

			state = get_children()[0]
			state.enter()

func get_scripts_in_folder(folder_path: String) -> Array:
	var scripts := []

	var dir := Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin(true, true)

	while true:
		var file := dir.get_next()
		if file == "":
			break
		scripts.append(folder_path + file)

	dir.list_dir_end()
	return scripts

func _physics_process(delta: float) -> void:
	if state != null:
		state.physics_update(delta)

func transition_to(state_idx: int, conditional := "")  -> void:
	state.exit()
	state = get_children()[state_idx]
	state.enter(conditional)
