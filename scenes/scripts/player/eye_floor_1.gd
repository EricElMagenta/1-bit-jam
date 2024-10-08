extends Floor

@onready var input_axis = 1
@onready var fireball = load("res://scenes/objects/fire_ball.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	
# FUNCIÓN DE DISPARAR
func shoot():
	var instance_right = fireball.instantiate()
	var instance_left = fireball.instantiate()
	
	# BAALA QUE VA HACIA ATRÁS
	instance_left.dir = -1
	
	instance_right.set_name("fireball_r")
	instance_left.set_name("fireball_l")
	
	# SE USA VECTOR 2 PARA AJUSTAR EL PUNTO DE ORIGEN DE LAS BALAS
	instance_right.spawn_pos = global_position + Vector2(20, 0) 
	instance_left.spawn_pos = global_position + Vector2(-20, 0)
	
	# INSTANCIA LAS BALAS
	call_deferred("add_sibling", instance_right)
	call_deferred("add_sibling", instance_left)
