extends Node2D

@onready var player = get_node("CharacterBody2D")

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)


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
