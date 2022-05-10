extends Character
class_name Enemy

export (int) var chase_range

var target

func spawn() -> void:
	target = get_player()
	root.create_tween(self, "scale", Vector2(), Vector2.ONE, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, false)

func get_player():
	var player

	for character in root.get_node("characters").get_children():
		if character.has_method("get_input_x"):
			player = character

	return player

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		fists.look_at(target.position)
