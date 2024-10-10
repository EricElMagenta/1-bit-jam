extends CharacterBody2D

@onready var sound_destroyed = $SoundDestroyed

func _physics_process(_delta):
	pass


func _on_area_2d_body_entered(_body):
	sound_destroyed.play()
	queue_free()
	
	var boxes = get_tree().get_nodes_in_group("Boxes")
	
	if boxes.size() == 1:
		Events.all_boxes_destroyed.emit()
