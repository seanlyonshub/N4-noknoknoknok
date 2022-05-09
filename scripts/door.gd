extends Character
class_name Door

export (PackedScene) var packed_enemy = null
export (PackedScene) var packed_weapon = null

func kill() -> void:
	if packed_enemy != null:
		spawn_enemy()
	.kill()

func spawn_enemy() -> void:
	var new_enemy = packed_enemy.instance()

	root.add_child(new_enemy)
	new_enemy.root = root
	new_enemy.spawn()
	new_enemy.position = global_position

	if packed_weapon != null:
		var new_weapon = packed_weapon.instance()

		new_enemy.fists.add_child(new_weapon)
		new_enemy.weapon = new_weapon
		#new_weapon.position = new_enemy.fists.position
