class_name Apple
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var head = body as Head
	if head:
		head.apple_eaten()
		GameManager.on_apple_eaten.emit()
		queue_free()
