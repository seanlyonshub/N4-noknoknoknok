extends State

func physics_update(_delta: float) -> void:
	if is_instance_valid(character.target):
		if character.position.distance_to(character.target.position) > character.chase_range:
			state_machine.transition_to(0)

		if character.ray.is_colliding() and character.ray.get_collider() == character.target:
			state_machine.transition_to(1)

		else:
			for scent_trail in character.target.scent_trail.scent_trails:
				character.ray.cast_to = scent_trail.position - character.position
				character.ray.force_raycast_update()

				if !character.ray.is_colliding():
					character.velocity = character.ray.cast_to
					break

	else:
		state_machine.transition_to(0)
