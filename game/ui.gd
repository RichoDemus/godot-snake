extends CanvasLayer

@export var score_label: Label
@export var pause_label: Label
@export var main_menu: Container
@export var score_upload: Container
@export var username: LineEdit
@export var upload_button: Button
@export var high_score_screen: Container
@export var not_high_score_screen: Control
@export var high_score_list: Label

var score:int = 0

func _ready() -> void:
	high_score_screen.visible = false
	not_high_score_screen.visible = true

func increment_score() -> void:
	score += 1
	score_label.text = "Score: " + str(score)
	
func reset_score() -> void:
	score = 0
	score_label.text = "Score: " + str(score)
	upload_button.disabled = false
	
func _process(delta: float) -> void:
	pause_label.visible = GameManager.paused
	main_menu.visible = !GameManager.running
	score_upload.visible = !GameManager.running && score > 0


func _on_upload_score_button_pressed() -> void:
	var usr = username.text
	username.text = ""
	GameManager.upload_score(usr, score)
	upload_button.disabled = true


func _on_high_score_buton_pressed() -> void:
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://snake.richodemus.com")
	high_score_screen.visible = true
	not_high_score_screen.visible = false


func _on_close_high_score_button_pressed() -> void:
	high_score_screen.visible = false
	not_high_score_screen.visible = true
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	high_score_list.text = ""
	for score in json:
		high_score_list.text += score.name + ": " + str(score.score) + "\n"
