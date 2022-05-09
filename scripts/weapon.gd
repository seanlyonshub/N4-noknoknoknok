extends Node2D
class_name Weapon

export (int) var damage = 1
export (int) var weapon_range = 16
export (int) var knockback = 4
export (int) var fire_rate = 30

var weapon_owner

onready var root = self.owner
onready var area = get_node("area")
onready var collision = area.get_node("collision")
