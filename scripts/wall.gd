extends StaticBody2D
class_name Wall

func get_collision_shapes() -> Array:
	var collision_shapes := []
	for child in get_children():
		if child is CollisionPolygon2D:
			collision_shapes.append(child)
	return collision_shapes

func get_polygons() -> Array:
	var polygons := []
	for child in get_children():
		if child is Polygon2D:
			polygons.append(child)
	return polygons

func generate_collision_shapes() -> void:
	for polygon in get_polygons():
		var new_polygon = CollisionPolygon2D.new()
		add_child(new_polygon)

	for idx in get_collision_shapes().size():
		get_collision_shapes()[idx].polygon = get_polygons()[idx].polygon
		get_collision_shapes()[idx].position = get_polygons()[idx].position
		get_collision_shapes()[idx].rotation = get_polygons()[idx].rotation
		get_collision_shapes()[idx].scale = get_polygons()[idx].scale

func _ready() -> void:
	generate_collision_shapes()
