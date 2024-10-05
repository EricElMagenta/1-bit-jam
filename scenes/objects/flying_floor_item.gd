extends Floor_item

var floor_type = "flying_floor_1"

func _on_body_entered(body):
	emit_signal("got_floor", floor_type)
	queue_free()
