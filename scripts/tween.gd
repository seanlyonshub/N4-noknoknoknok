extends Tween

export (bool) var kills_parent = false

func _on_tween_tween_all_completed() -> void:
	if kills_parent:
		get_parent().queue_free()

	queue_free()
