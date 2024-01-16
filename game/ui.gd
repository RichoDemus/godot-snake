extends CanvasLayer

@export var score_label: Label
@export var pause_label: Label
@export var main_menu: Container
@export var score_upload: Container
@export var username: LineEdit
@export var upload_button: Button

var score:int = 0

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
