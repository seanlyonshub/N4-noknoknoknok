extends State

func physics_update(_delta: float) -> void:
	character.velocity.x = character.get_input_x()
	character.velocity.y = character.get_input_y()

	if character.get_input_x() == 0 and character.get_input_y() == 0:
		state_machine.transition_to(0)
