extends Floor_item

var floor_type = "mouth_floor_1"

func _on_body_entered(_body):
	emit_signal("got_floor", floor_type)
	queue_free()
