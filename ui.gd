extends CanvasLayer

@export var score_label: Label
@export var pause_label: Label
@export var main_menu: Container

var score:int = 0

func increment_score() -> void:
	score += 1
	score_label.text = "Score: " + str(score)
	
func reset_score() -> void:
	score = 0
	score_label.text = "Score: " + str(score)
	
func _process(delta: float) -> void:
	pause_label.visible = GameManager.paused
	main_menu.visible = !GameManager.running
