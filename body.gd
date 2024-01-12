class_name Body
extends Area2D

var child:Body
var last_position: Vector2

func update_position(parent_position: Vector2) -> void:
	var direction = parent_position.direction_to(last_position)
	if direction == Vector2.ZERO:
		direction = Vector2.LEFT
	global_position = parent_position + direction * 50 # todo constant
	last_position = global_position
	if child:
		child.update_position(global_position)

func get_last_child() -> Body:
	if child:
		return child.get_last_child()
	return self
