class_name Head
extends CharacterBody2D


const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
var child: Body
const body_scene: PackedScene = preload("res://body.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity = Vector2.RIGHT * SPEED


func _physics_process(delta: float) -> void:
	var input_velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		input_velocity.x += 1
	elif Input.is_action_pressed("move_left"):
		input_velocity.x -= 1
	elif Input.is_action_pressed("move_down"):
		input_velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		input_velocity.y -= 1

	if input_velocity != Vector2.ZERO:
		velocity = input_velocity.normalized() * SPEED
	
	move_and_slide()
	if child:
		child.update_position(global_position)
	
func apple_eaten() -> void:
	print("I ate an apple")
	grow_longer.call_deferred()
	
	
func grow_longer() -> void:
	var body: Body = body_scene.instantiate() as Body
	if child:
		var last_child = child.get_last_child()
		last_child.child = body
		last_child.add_child(body)
	else:
		child = body
		add_child(body)
