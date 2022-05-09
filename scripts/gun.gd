extends Weapon
class_name Gun

export (PackedScene) var bullet

export (float) var bullet_spread = 1
export (int) var bullet_speed = 3
export (int) var bullet_amount = 1
export (int) var ammo = 30

var fire_timer : int
var is_firing : bool

onready var barrel = get_node("barrel")

func fire() -> void:
	if !is_firing and ammo > 0:
		ammo -= bullet_amount
		weapon_owner = get_parent().get_parent()

		for idx in range(bullet_amount):
			var new_bullet = bullet.instance()
			root.add_child(new_bullet)
			new_bullet.position = barrel.global_position
			new_bullet.rotation = get_parent().rotation
			new_bullet.velocity = (weapon_owner.ray.cast_to + weapon_owner.position) - new_bullet.position
			new_bullet.weapon = self

			randomize()
			new_bullet.velocity = new_bullet.velocity.rotated(rand_range(-0.1 * bullet_spread, 0.1 * bullet_spread))
		is_firing = true

func _physics_process(_delta: float) -> void:
	if is_firing:
		fire_timer += 1
		if fire_timer % fire_rate == 0:
			is_firing = false
