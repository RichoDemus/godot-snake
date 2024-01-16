extends Node

@export var apple_scene: PackedScene
@export var head_scene: PackedScene
var head: Head
var apple: Apple
signal on_apple_eaten
var play_area:Rect2 = Rect2(0,0,ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
var paused:bool = false
var running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func start_game() -> void:
	UI.reset_score()
	spawn_apple()
	spawn_snake()
	paused = false
	running = true

func stop_game() -> void:

	running = false
	pass
	
func upload_score(name:String, score:int) -> void:
	var json = JSON.stringify({"name":name,"score":  score})
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("https://snake.richodemus.com", headers, HTTPClient.METHOD_POST, json)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		if !running:
			start_game()
		else:
			paused = !paused

func spawn_apple() -> void:
	if apple:
		apple.queue_free()
	var x = randf_range(play_area.position.x + 30, play_area.end.x - 30)
	var y = randf_range(play_area.position.y + 30, play_area.end.y - 30)
	apple = apple_scene.instantiate()
	apple.position = Vector2(x,y)
	add_child.call_deferred(apple)
	UI.increment_score()
	
func spawn_snake() -> void:
	if head:
		head.queue_free()
		for child in get_children():
			if child is Body:
				child.queue_free()
	head = head_scene.instantiate()
	head.position = Vector2(100,100)
	add_child.call_deferred(head)
