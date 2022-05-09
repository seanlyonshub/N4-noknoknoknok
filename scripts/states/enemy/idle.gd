extends State

func enter(conditional := "") -> void:
	character.velocity = Vector2()

func physics_update(_delta: float) -> void:
	if is_instance_valid(character.target):
		if character.position.distance_to(character.target.position) < character.chase_range:
			state_machine.transition_to(1)
