extends Node
class_name State

onready var state_machine = get_parent() as StateMachine
onready var character = state_machine.owner as Character

func physics_update(_delta: float) -> void:
	pass

func enter(conditional := "") -> void:
	pass

func exit() -> void:
	pass
