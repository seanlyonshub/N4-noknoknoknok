extends Character
class_name Enemy

export (int) var chase_range

var target

func _ready() -> void:
	scale = Vector2.ZERO
	collision.scale = Vector2.ZERO

func get_player():
	var player

	for character in root.get_node("characters").get_children():
		if character.has_method("get_input_x"):
			player = character

	return player

func spawn(door) -> void:
	target = get_player()
	root.create_tween(self, "scale", Vector2(), Vector2.ONE, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, false)
	root.create_tween(self, "position", position, door.position + ((door.position - position) * 4), 0.9, Tween.TRANS_LINEAR, Tween.EASE_OUT, false)
	root.create_tween(collision, "scale", Vector2(), Vector2.ONE, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, false)

func _physics_process(delta: float) -> void:
	print(health)
	if target != null:
		ray.cast_to = target.position - position
		fists.look_at(target.position)
