extends CharacterBody2D

const FLOOR_HEIGHT = 17

@onready var player = get_parent().get_node("CharacterBody2D") # Referencia al jugador
@onready var floor_index = len(player.floors) # Conteo de pisos

var collision_detected = false

func _ready():
	position = Vector2(player.position.x, player.position.y - (floor_index * FLOOR_HEIGHT) + 5)

func _physics_process(_delta):
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_movement(input_axis)

	move_and_slide()

# Detectar colision de torres
func handle_movement(input_axis):
	if is_on_wall(): #Colisión detectada
		collision_detected = true
	
	elif (!input_axis && is_on_wall()) || !is_on_wall(): #Colisión terminada
		collision_detected = false
	
	position = Vector2(player.position.x, player.position.y - (floor_index * FLOOR_HEIGHT) + 5)
