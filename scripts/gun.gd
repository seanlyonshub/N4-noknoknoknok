extends Weapon
class_name Gun

export (PackedScene) var bullet

export (int) var bullet_speed = 6
export (int) var fire_rate = 9
export (int) var ammo = 30

var fire_timer : int
var is_firing : bool

onready var barrel = get_node("barrel")

func fire() -> void:
	if !is_firing and ammo > 0:
		ammo -= 1
		var weapon_owner = get_parent().get_parent()
		var new_bullet = bullet.instance()

		root.add_child(new_bullet)
		new_bullet.position = barrel.global_position

		new_bullet.velocity = (weapon_owner.ray.cast_to + weapon_owner.position) - new_bullet.position
		new_bullet.speed = bullet_speed
		new_bullet.weapon_owner = weapon_owner
		is_firing = true

func _physics_process(_delta: float) -> void:
	if is_firing:
		fire_timer += 1
		if fire_timer % fire_rate == 0:
			is_firing = false
