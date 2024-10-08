extends CharacterBody2D

func _physics_process(delta):
	pass


func _on_area_2d_body_entered(body):
	queue_free()
	
	var boxes = get_tree().get_nodes_in_group("Boxes")
	
	if boxes.size() == 1:
		Events.all_boxes_destroyed.emit()
