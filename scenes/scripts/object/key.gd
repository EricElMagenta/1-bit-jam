extends Area2D

func _on_body_entered(body):
	Events.stage_clear.emit()
	queue_free()
