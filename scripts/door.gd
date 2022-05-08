extends Character
class_name Door

export (NodePath) var enemy

func kill() -> void:
	if is_instance_valid(get_node(enemy)):
		spawn_character(enemy)
	.kill()

func spawn_character(character) -> void:
	get_node(character).spawn(self)
