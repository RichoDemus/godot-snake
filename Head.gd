class_name Head
extends Area2D


const SPEED = 200.0
var velocity: Vector2 = Vector2.RIGHT
#const JUMP_VELOCITY = -400.0
var child: Body
const body_scene: PackedScene = preload("res://body.tscn")
var alive:bool = true
var body_count: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	grow_longer.call_deferred(5)

	pass

func _physics_process(delta: float) -> void:
	if !alive:
		return
	if Input.is_action_pressed("move_right"):
		velocity = velocity.rotated(4 * delta).normalized()
		look_at(position+velocity)
	if Input.is_action_pressed("move_left"):
		velocity = velocity.rotated(-4 * delta).normalized()
		look_at(position+velocity)
	
	position += velocity * SPEED * delta
	
	if position.x < 16 || position.y < 16 || position.x > GameManager.play_area.end.x-16 || position.y > GameManager.play_area.end.y-16:
		print("OOB: " + str(position))
		alive = false
		$HeadSprite.hide()
		$DeadSprite.show()
	
	if child:
		child.update_position(position)
		var children = child.get_positions(global_position)
		var tail_coords = children.slice(-10)
		var body_coords = children.slice(0, -6)
		$BodyLine.points = body_coords
		$TailLine.points = tail_coords
	
func apple_eaten() -> void:
	print("I ate an apple")
	grow_longer.call_deferred(5)
	
	
func grow_longer(segments: int) -> void:
	for n in segments:
		var body: Body = body_scene.instantiate() as Body
	
		body.id = body_count
		body_count += 1
		print("spawned body " + str(body_count))
		if child:
			var last_child = child.get_last_child()
			body.position = last_child.position
			last_child.child = body
			GameManager.add_child(body)
		else:
			child = body
			body.position = position
			GameManager.add_child(body)


func _on_area_entered(other: Area2D) -> void:
	var body = other as Body
	if body:
		print("collided with body " + str(body.id))
		alive = false
		$HeadSprite.hide()
		$DeadSprite.show()
