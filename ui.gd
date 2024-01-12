extends CanvasLayer

@export var score_label: Label

func set_score(score: int) -> void:
	score_label.text = "Score: " + str(score)
