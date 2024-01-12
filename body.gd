class_name Body
extends Area2D

var child:Body
var last_position: Vector2
var id:int
var upcoming_positions: Array[Vector2] = []

func _ready() -> void:
	if id < 40:
		collision_layer = 2

func update_position(parent_position: Vector2) -> void:
	upcoming_positions.push_back(parent_position)
	var distance_to_next_point = global_position.distance_to(parent_position)
	var old_position
	while distance_to_next_point > 0.1:
		old_position = global_position
		global_position = upcoming_positions.pop_front()
		distance_to_next_point = global_position.distance_to(parent_position)
	if old_position:
		if !upcoming_positions.is_empty():
			look_at(upcoming_positions[0])
		if child:
			child.update_position(old_position)

func get_last_child() -> Body:
	if child:
		return child.get_last_child()
	return self

func get_positions(base:Vector2) -> Array[Vector2]:
	if child:
		var res = child.get_positions(base)
		res.push_front(global_position)
		return res
	else:
		var res:Array[Vector2] = []
		res.append(global_position)
		return res
