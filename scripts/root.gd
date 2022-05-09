extends Node2D

export (PackedScene) var packed_tween
export (PackedScene) var packed_sfx

onready var camera = get_node("camera")
onready var weapons = get_node("weapons")

func create_tween(node, property: String, from, to, duration, trans_type, ease_type, kills_parent := false) -> void:
	var new_tween = packed_tween.instance()
	node.add_child(new_tween)
	new_tween.kills_parent = kills_parent

	new_tween.interpolate_property(node, property, from, to, duration, trans_type, ease_type)
	new_tween.start()

func create_sfx(sfx_path: String) -> void:
	var new_sfx = packed_sfx.instance()

	add_child(new_sfx)
	new_sfx.play_random_sound(sfx_path)

func shake_screen(value: float = 1) -> void:
	create_tween(camera, "zoom", Vector2.ONE * (2 + (0.1 * value)), Vector2.ONE * 2, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)
	create_tween(camera, "offset", Vector2.ONE * (1 * value), Vector2.ZERO, 0.3 * value, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)
	create_tween(camera, "rotation_degrees", 1 * value, rotation_degrees, 0.3 * value, Tween.TRANS_BOUNCE, Tween.EASE_OUT, false)
