extends Node

@export var apple_scene: PackedScene
signal on_apple_eaten

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_apple()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_apple() -> void:
	var x = 600 * randf()
	var y = 600 * randf()
	var apple = apple_scene.instantiate()
	apple.position = Vector2(x,y)
	add_child.call_deferred(apple)
	UI.increment_score()
