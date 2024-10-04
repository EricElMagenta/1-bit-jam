extends Node2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var player = get_node("CharacterBody2D")
@onready var floor_nodes = []

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	polygon_2d.polygon = collision_polygon_2d.polygon

func _physics_process(_delta):
	floor_nodes = get_tree().get_nodes_in_group("Floors")
	if len(player.floors) > 1:
		if Input.is_action_just_pressed("swap_floor_up"): swap_floors_up()
		if Input.is_action_just_pressed("swap_floor_down"): swap_floors_down()
		

# CAMBIA EL ORDEN DE LOS PISOS DE ARRIBA HACIA ABAJO O AL REVÉS
func swap_floors_up():
	print("UP")
	for i in range(player.floors.size()-1):
		if i != len(player.floors)-1: 
			var aux_floor_index = player.floors[i].floor_index
			player.floors[i].floor_index = player.floors[i+1].floor_index
			player.floors[i+1].floor_index = aux_floor_index

func swap_floors_down():
	print("DOWN	")
	for i in range(player.floors.size()-1, -1, -1):
		if i != len(player.floors)-1: 
			var aux_floor_index = player.floors[i].floor_index
			player.floors[i].floor_index = player.floors[i-1].floor_index
			player.floors[i-1].floor_index = aux_floor_index

		#if i != len(player.floors)-1: 
		#	player.floors[i].floor_index = player.floors[len(player.floors)-1].floor_index
			
		#var aux_floor_index = player.floors[0].floor_index
		#player.floors[0].floor_index = player.floors[1].floor_index 
		#player.floors[1].floor_index = aux_floor_index
