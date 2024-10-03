extends CharacterBody2D

const FLOOR_HEIGHT = 17

@export var movement_data : PlayerMovementData # RESOURCE DEL MOVIMIENTO
@onready var animated_sprite_2d = $AnimatedSprite2D # REFERENCIA AL NODO animated sprite 2d
@onready var up_raycast = $UpRaycast # RAYCAST PARA TECHOS (DEBE ESTAR SIEMPRE POR ENCIMA DE LA ÚLTIMA TORRE)
var floors = []

# ================================================ FUNCCIÓN READY ===================================================================================
# AGREGAR PISOS AL AGARRAR UNO (NI IDEA PORQUE VA EN _ready())
func _ready():
	var items = get_tree().get_nodes_in_group("FloorItems")
	for item in items:
		item.got_floor.connect(add_floor.bind(item.floor_type, item))
		
	#get_tree().get_first_node_in_group("FloorItems").connect("got_floor", add_floor)
	#Events.got_floor.connect(add_floor) 
	#Events.got_floor.connect(add_floor.bind("floor_type")) 
	
# ================================================ FUNCIÓN PRINCIPAL =================================================================================
func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	handle_jump()
	
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_movement(input_axis, delta)
	apply_friction(input_axis)
	update_animations(input_axis)

	move_and_slide()
	
	# Reiniciar nivel
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

# =============================================== FUNCIONES AUXILIARES ===================================================================================
# MOVIMIENTO
func handle_movement(input_axis, delta):
	#if !is_on_floor(): return
	if !detect_collisions():
		if input_axis:
			velocity.x = input_axis * movement_data.SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, movement_data.SPEED * delta)
	else:
		velocity.x = 0
		
	if up_raycast.is_colliding():
		velocity.y = 30

# DETECCIÓN DE COLISIONES EN LOS PISOS
func detect_collisions():
	if len(floors) > 0:
		for i in range(len(floors)):
			if floors[i].collision_detected:
				return true
	return false

# SALTO
func handle_jump():
	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
		velocity.y = movement_data.JUMP_VELOCITY

# DETECTAR COLISIÓN CON LOS TECHOS
func update_up_shapecast():
	up_raycast.position.y -= FLOOR_HEIGHT 

# FRICCIÓN
func apply_friction(input_axis):
	if !input_axis and is_on_floor():
		velocity.x = 0
		
# ANIMACIONES DE LAS PATITAS
func update_animations(input_axis):
	if input_axis:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("Walk")
	else:
		animated_sprite_2d.play("Idle")
		
	if !is_on_floor():
		animated_sprite_2d.play("Jump")

# =================================================== SEÑALES =========================================================================================== 
# AGREGAR PISO (SE MODIFICARÁ CUANDO SE AGREGUEN MÁS TIPOS DE PISOS)
func add_floor(floor_type, _a, _b):
	print(floor_type)
	var scene = load("res://scenes/player/normal_floor_1.tscn")
	var scene_instance = scene.instantiate()
	floors.append(scene_instance)
	up_raycast.enabled = true
	update_up_shapecast()
	#print(get_tree().get_nodes_in_group("Floors").size())
	call_deferred("add_sibling", scene_instance)
