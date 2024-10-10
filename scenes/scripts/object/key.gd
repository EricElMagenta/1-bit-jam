extends Area2D

func _on_body_entered(_body):
	Events.stage_clear.emit()
