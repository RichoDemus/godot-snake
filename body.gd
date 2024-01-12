class_name Body
extends Area2D

var child:Body
var last_position: Vector2
var id:int
var upcoming_positions: Array[Vector2] = []

func _ready() -> void:
	if id < 10:
		collision_layer = 2

func update_position(parent_position: Vector2) -> void:
	upcoming_positions.push_back(parent_position)
	var distance_to_next_point = global_position.distance_to(parent_position)
	if distance_to_next_point > 0.1:
		var old_position = position
		position = upcoming_positions.pop_front()
		if !upcoming_positions.is_empty():
			look_at(upcoming_positions[0])
		if child:
			child.update_position(old_position)


func get_last_child() -> Body:
	if child:
		return child.get_last_child()
	return self
