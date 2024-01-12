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

func _process(delta: float) -> void:
	if !alive:
		return
	if Input.is_action_pressed("move_right"):
		velocity = velocity.rotated(4 * delta).normalized()
		look_at(position+velocity)
	if Input.is_action_pressed("move_left"):
		velocity = velocity.rotated(-4 * delta).normalized()
		look_at(position+velocity)
	
	position += velocity * SPEED * delta
	
	if position.x < 16 || position.y < 16 || position.x > get_viewport().size.x-16 || position.y > get_viewport().size.y-16:
		alive = false
		$HeadSprite.hide()
		$DeadSprite.show()
	

	if child:
		child.update_position(position)
	
func apple_eaten() -> void:
	print("I ate an apple")
	grow_longer.call_deferred(5)
	
	
func grow_longer(segments: int) -> void:
	for n in segments:
		var body: Body = body_scene.instantiate() as Body
	
		body.id = body_count
		body_count += 1
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
		alive = false
		$HeadSprite.hide()
		$DeadSprite.show()
