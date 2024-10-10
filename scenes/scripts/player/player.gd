extends CharacterBody2D
class_name Player

const FLOOR_HEIGHT = 17

@export var movement_data : PlayerMovementData # RESOURCE DEL MOVIMIENTO
@onready var animated_sprite_2d = $AnimatedSprite2D # REFERENCIA AL NODO animated sprite 2d
@onready var up_raycast = $UpRaycast # RAYCAST PARA TECHOS (DEBE ESTAR SIEMPRE POR ENCIMA DE LA ÚLTIMA TORRE)
@onready var hovering_timer = $HoveringTimer
@onready var area_2d = $Area2D
var floors = []

# ================================================ FUNCCIÓN READY ===================================================================================
# AGREGAR PISOS AL AGARRAR UNO (NI IDEA PORQUE VA EN _ready())
func _ready():
	var items = get_tree().get_nodes_in_group("FloorItems")
	for item in items:
		item.got_floor.connect(add_floor.bind(item.floor_type, item))
	reset_jumps()
	
# ================================================ FUNCIÓN PRINCIPAL =================================================================================
func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	handle_jump()
	#if movement_data.double_jump_acquired: handle_hovering()

	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_movement(input_axis, delta)
	apply_friction(input_axis)
	update_animations(input_axis)

	move_and_slide()
	
	# Reiniciar nivel
	if Input.is_action_just_pressed("restart_level"):
		restart_level()

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
	# RECARGA SALTOS EN EL AIRE CUANDO TOCA EL SUELO
	if is_on_floor() && movement_data.double_jump_acquired: 
		movement_data.can_air_jump = true
		movement_data.air_jumps = movement_data.max_air_jumps
	
	# SALTO NORMAL
	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
		velocity.y = movement_data.JUMP_VELOCITY
	
	# SALTO EN EL AIRE
	if !is_on_floor():
		if Input.is_action_just_pressed("ui_up") && movement_data.can_air_jump && movement_data.air_jumps > 0:
			velocity.y = movement_data.JUMP_VELOCITY
			movement_data.air_jumps -= 1
			if movement_data.air_jumps < 1: movement_data.can_air_jump = false

func handle_hovering():
	if is_on_floor(): movement_data.can_hover = true
	if velocity.y > 0 && Input.is_action_pressed("ui_up") && movement_data.can_hover:
		if hovering_timer.time_left > 0.0:
			velocity.y = 0
			
		if hovering_timer.is_stopped() || !Input.is_action_pressed("ui_up"): 
			movement_data.can_hover = false
	
	elif !Input.is_action_pressed("ui_up"):
		hovering_timer.start()

# DETECTAR COLISIÓN CON LOS TECHOS
func update_up_shapecast():
	up_raycast.position.y -= FLOOR_HEIGHT 
	#if len(floors) == 1: area_2d.scale.x = 1.6
	#area_2d.position.y -= 8.38
	#area_2d.scale.y += 1.65
	

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

func reset_jumps():
	movement_data.double_jump_acquired = false
	movement_data.air_jumps = 0
	movement_data.max_air_jumps = 0

func restart_level():
	get_tree().reload_current_scene.call_deferred()

# =================================================== SEÑALES =========================================================================================== 
# AGREGAR PISO (SE MODIFICARÁ CUANDO SE AGREGUEN MÁS TIPOS DE PISOS)
func add_floor(floor_type, _a, _b):
	var new_floor = "res://scenes/player/" + floor_type + ".tscn"
	var scene = load(new_floor)
	var scene_instance = scene.instantiate()
	floors.append(scene_instance)
	up_raycast.enabled = true
	update_up_shapecast()
	call_deferred("add_sibling", scene_instance)


func _on_area_2d_body_entered(body):
	if body is EnemyBulletLeft || body is EnemyBulletRight:
		#get_tree().reload_current_scene.call_deferred()
		restart_level()
