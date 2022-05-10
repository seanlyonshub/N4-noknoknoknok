extends KinematicBody2D
class_name Character

export (int) var speed = 64
export (int) var health = 4

export (String) var kill_sfx = ""
export (String) var hurt_sfx = ""

var direction : Vector2
var velocity : Vector2
var last_x_direction := 1.0
var init_speed : int

var i_frames : int
var just_hurt : bool
var has_killed : bool

var attack_frames : int
var is_attacking : bool
var grab_frames : int
var is_grabbing : bool

var weapon

onready var collision = get_node("collision")
onready var fists = get_node("fists")
onready var polygon = get_node("polygon")
onready var ray = get_node("ray")
onready var state_machine = get_node("state_machine")
onready var root = self.owner

func _ready() -> void:
	init_speed = speed

func kill() -> void:
	if !has_killed:
		has_killed = true

		if weapon != null:
			throw()

		if kill_sfx != "":
			root.create_sfx(kill_sfx)
		root.shake_screen(2)
		collision.queue_free()
		root.create_tween(self, "scale", scale, Vector2(), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, true)

		if is_instance_valid(state_machine):
			state_machine.transition_to(0)
			state_machine.queue_free()

func hurt(value: int = 1) -> void:
	if !just_hurt:
		just_hurt = true
		health -= value
		if health > 0:
			if hurt_sfx != "":
				print(hurt_sfx)
				root.create_sfx(hurt_sfx)
			root.shake_screen(1)

		else:
			kill()

func grab() -> void:
	if !is_grabbing:
		root.create_tween(fists, "position", ray.cast_to.normalized() * get_weapon_range(), Vector2(), 0.6, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)
		root.create_tween(fists, "scale", Vector2.ONE * 2, Vector2.ONE, 0.6, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)

	is_grabbing = true

func throw() -> void:
	root.create_tween(fists, "position", ray.cast_to.normalized() * get_weapon_range(), Vector2(), 0.6, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)

	fists.remove_child(weapon)
	root.weapons.add_child(weapon)
	weapon.position = fists.global_position
	weapon.rotation = fists.rotation
	weapon = null

func attack() -> void:
	if !is_attacking:
		root.create_tween(fists, "position", ray.cast_to.normalized() * get_weapon_range(), Vector2(), 0.6, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)

	if weapon != null:
		if weapon is Gun:
			weapon.fire()

	is_attacking = true

func knockback(body, weapon_knockback) -> void:
	root.create_tween(polygon, "rotation_degrees", 30 * last_x_direction, rotation_degrees, 0.6, Tween.TRANS_CUBIC, Tween.EASE_OUT, false)
	root.create_tween(self, "velocity", position - body.position, Vector2(), 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)
	root.create_tween(self, "speed", 32 * weapon_knockback, init_speed, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)

func check_weapon_area() -> void:
	if is_attacking:
		if ray.is_colliding():
			var body = ray.get_collider()
			if body.has_method("hurt"):
				if get_weapon_area().overlaps_body(body):
					if !body.just_hurt:
						body.knockback(self, get_weapon_knockback())

					if weapon == null or weapon.damage == 0:
						if body.has_method("spawn_enemy"):
							body.hurt()

						body.hurt(0)

					else:
						body.hurt(weapon.damage)

					attack_frames = 0
					is_attacking = false

	if is_grabbing:
		if weapon == null:
			if !get_weapon_area().get_overlapping_areas().empty():
				var area_parent = get_weapon_area().get_overlapping_areas()[0].get_parent()
				ray.cast_to = area_parent.position - position
				ray.force_raycast_update()
				if !ray.is_colliding():
					if area_parent is Weapon and area_parent.get_parent() == root.weapons:
						area_parent.get_parent().remove_child(area_parent)
						fists.add_child(area_parent)
						area_parent.root = root
						area_parent.position = Vector2.ZERO
						area_parent.rotation = 0
						area_parent.weapon_owner = self
						weapon = area_parent

func get_weapon_knockback() -> int:
	if weapon == null:
		return 6

	return weapon.knockback

func get_weapon_area():
	if weapon == null:
		return fists.get_node("area")

	return weapon.get_node("area")

func get_weapon_range() -> int:
	if weapon == null:
		return 16

	return weapon.weapon_range

func get_weapon_fire_rate() -> int:
	if weapon == null:
		return 15

	return weapon.fire_rate

func _physics_process(_delta: float) -> void:
	direction = velocity.normalized().round()
	velocity = direction * speed
	polygon.rotation_degrees = direction.x * speed / 8

	fists.scale.y = sign(ray.cast_to.x)

	if direction.x != 0:
		last_x_direction = direction.x

	move_and_slide(velocity, Vector2.UP)

	if just_hurt:
		i_frames += 1
		if i_frames % 30 == 0:
			just_hurt = false

	if is_attacking:
		check_weapon_area()
		attack_frames += 1
		if attack_frames % get_weapon_fire_rate() == 0:
			is_attacking = false

	if is_grabbing:
		check_weapon_area()
		grab_frames += 1
		if grab_frames % 15 == 0:
			is_grabbing = false
