extends CanvasLayer

@export var score_label: Label
var score:int = 0

func increment_score() -> void:
	score += 1
	score_label.text = "Score: " + str(score)
