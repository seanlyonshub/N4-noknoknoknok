extends Weapon
class_name Bullet

var velocity : Vector2
var speed : int
var weapon_owner

func _ready() -> void:
	get_parent().create_tween(self, "scale", Vector2(), Vector2.ONE, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, false)
 
func _physics_process(delta: float) -> void:
	position += velocity.normalized() * speed

	if !area.get_overlapping_bodies().empty():
		var body = area.get_overlapping_bodies()[0]
		if body.has_method("hurt"):
			body.hurt(damage)
			body.knockback(weapon_owner, knockback)
		get_parent().create_tween(self, "scale", Vector2.ONE, Vector2(), 0.01, Tween.TRANS_LINEAR, Tween.EASE_OUT, true)
