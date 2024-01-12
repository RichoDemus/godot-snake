extends Node

@export var apple_scene: PackedScene
signal on_apple_eaten
var play_area:Rect2 = Rect2(0,0,ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_apple()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_apple() -> void:
	var x = randf_range(play_area.position.x, play_area.end.x)
	var y = randf_range(play_area.position.y, play_area.end.y)
	var apple = apple_scene.instantiate()
	apple.position = Vector2(x,y)
	add_child.call_deferred(apple)
	UI.increment_score()
