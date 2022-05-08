extends Camera2D

export (NodePath) var camera_target

onready var root = self.owner
onready var target = get_node(camera_target)

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		position += (target.position - position) * delta * 16
