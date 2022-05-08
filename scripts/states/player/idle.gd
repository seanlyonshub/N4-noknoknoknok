extends State

func enter(conditional := "") -> void:
	character.velocity = Vector2()

func physics_update(_delta: float) -> void:
	if character.get_input_x() != 0 or character.get_input_y() != 0:
		state_machine.transition_to(1)
