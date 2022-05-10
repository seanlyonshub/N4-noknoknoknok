extends KinematicBody2D
class_name Projectile

export (int) var damage = 2
export (int) var speed = 256

var weapon
var velocity : Vector2
var direction : Vector2

onready var area = get_node("area")
onready var collision = area.get_node("collision")

func _ready() -> void:
	get_parent().create_tween(self, "scale", Vector2(), Vector2.ONE, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, false)

func _physics_process(delta: float) -> void:
	direction = velocity.normalized()
	velocity = direction * speed

	move_and_slide(velocity, Vector2.UP)

	if !area.get_overlapping_bodies().empty():
		if area.get_overlapping_bodies()[0] == weapon.weapon_owner:
			return

		for body in area.get_overlapping_bodies():
			if body.has_method("hurt"):
				body.hurt(damage)
				body.knockback(weapon.weapon_owner, weapon.knockback)
		collision.queue_free()
		velocity = Vector2()
		get_parent().create_tween(self, "scale", Vector2.ONE, Vector2(0, 4), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, true)
