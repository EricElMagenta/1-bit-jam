extends Node2D

@onready var player = get_node("Player")
@onready var key = load("res://scenes/objects/key.tscn")
@onready var sound_key = $SoundKey

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.stage_clear.connect(stage_cleared)
	Events.all_boxes_destroyed.connect(all_boxes_destroyed_clear)

func _physics_process(_delta):
	if len(player.floors) > 1:
		if Input.is_action_just_pressed("swap_floor_up"): swap_floors_up()
		if Input.is_action_just_pressed("swap_floor_down"): swap_floors_down()


# CAMBIA EL ORDEN DE LOS PISOS DE ARRIBA HACIA ABAJO O AL REVÉS
func swap_floors_down():
	for i in range(player.floors.size()-1):
		if i != len(player.floors)-1: 
			var aux_floor_index = player.floors[i].floor_index
			var floor_aux = player.floors[i]
			
			player.floors[i].floor_index = player.floors[i+1].floor_index
			player.floors[i+1].floor_index = aux_floor_index
			
			player.floors[i] = player.floors[i+1]
			player.floors[i+1] = floor_aux

func swap_floors_up():
	for i in range(player.floors.size()-1, -1, -1):
		if i != len(player.floors)-1: 
			var aux_floor_index = player.floors[i].floor_index
			var floor_aux = player.floors[i]
			
			player.floors[i].floor_index = player.floors[i-1].floor_index
			player.floors[i-1].floor_index = aux_floor_index
			
			player.floors[i] = player.floors[i-1]
			player.floors[i-1] = floor_aux

func stage_cleared():
	if get_tree(): get_tree().change_scene_to_file.call_deferred("res://scenes/UI/end_screen.tscn")

func _on_dedzone_body_entered(body):
	player.restart_level()

func all_boxes_destroyed_clear():
	spawn_key()

func spawn_key():
	sound_key.play()
	var key_instance = key.instantiate()
	key_instance.position = Vector2(0, -100)
	call_deferred("add_child", key_instance)

func _on_ded_bullet_zone_r_body_entered(body):
	if body is EnemyBulletLeft:
		body.queue_free()

func _on_ded_bullet_zone_l_body_entered(body):
	if body is EnemyBulletRight:
		body.queue_free()
