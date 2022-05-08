extends State

var init_pos

func enter(conditional := "") -> void:
	init_pos = character.position

func physics_update(_delta: float) -> void:
	character.position = init_pos
