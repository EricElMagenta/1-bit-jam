extends CharacterBody2D
class_name Floor

const FLOOR_HEIGHT = 17

@onready var player = get_parent().get_node("CharacterBody2D") # Referencia al jugador
@onready var floor_index = len(player.floors) # Conteo de pisos
@onready var left_raycast = $LeftRaycast
@onready var right_raycast = $RightRaycast


var collision_detected = false
var left_ray_collision = false # Collision izq. con torres
var right_ray_collision = false # Collision der. con torres

func _ready():
	position = Vector2(player.position.x, player.position.y - (floor_index * FLOOR_HEIGHT) + 5)

func _physics_process(_delta):
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_movement(input_axis)

	move_and_slide()

# Detectar colision de torres
func handle_movement(input_axis):
	
	# Detectar las colisiones en las torres por izq. y der. mientras se camina hacia las paredes
	left_ray_collision = Input.is_action_pressed("ui_left") && left_raycast.is_colliding() 
	right_ray_collision = Input.is_action_pressed("ui_right") && right_raycast.is_colliding()
	
	#Colisión detectada (LA ÚLTIMA CONDICIÓN NO ES CORRECTA, PERO FUNCIONA POR AHORA Y RUEGA POR QUE NO DE PROBLEMAS EN EL FUTURO)
	if (left_ray_collision && input_axis == -1) || (right_ray_collision && input_axis == 1) || (!is_on_floor() && !input_axis): 
		collision_detected = true
	else:
		collision_detected = false
	#elif (!input_axis && is_on_wall()) || !is_on_wall(): #Colisión terminada
	#	collision_detected = false
	
	position = Vector2(player.position.x, player.position.y - (floor_index * FLOOR_HEIGHT) + 5)
