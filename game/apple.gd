class_name Apple
extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var head = area as Head
	if head:
		head.apple_eaten()
		GameManager.on_apple_eaten.emit()
		queue_free()
