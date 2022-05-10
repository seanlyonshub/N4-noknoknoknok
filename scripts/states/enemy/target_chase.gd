extends State

func physics_update(_delta: float) -> void:
	if is_instance_valid(character.target):
		character.ray.cast_to = character.target.position - character.position
		character.ray.force_raycast_update()

		character.velocity = character.ray.cast_to

		if character.position.distance_to(character.target.position) > character.chase_range:
			state_machine.transition_to(0)

		if character.weapon is Gun:
			if character.position.distance_to(character.target.position) > character.get_weapon_range() * 16:
				character.attack()
			if character.weapon.ammo < 1:
				character.throw()

		elif character.position.distance_to(character.target.position) < character.get_weapon_range():
			character.attack()

		if character.weapon == null:
			if !character.get_weapon_area().get_overlapping_areas().empty():
				var weapon = character.get_weapon_area().get_overlapping_areas()[0].get_parent()
				if weapon is Weapon and weapon.get_parent() == character.root.weapons:
					if weapon is Gun and weapon.ammo < 1:
						return

					character.grab()

		if character.ray.is_colliding() and !character.ray.get_collider() is Character:
			state_machine.transition_to(2)

	else:
		state_machine.transition_to(0)
