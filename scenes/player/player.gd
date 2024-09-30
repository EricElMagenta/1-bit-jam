extends CharacterBody2D

@export var movement_data : PlayerMovementData
@onready var animated_sprite_2d = $AnimatedSprite2D

var floors = []
#var tower_collision_detected = false

func _ready():
	Events.got_floor.connect(add_floor)

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	handle_jump()

	# Handle tower collisions
	print(detect_collisions())

	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_movement(input_axis, delta)
	apply_friction(input_axis)
	update_animations(input_axis)

	move_and_slide()

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

# SALTO
func handle_jump():
	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
		velocity.y = movement_data.JUMP_VELOCITY

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

# AGREGAR PISO
func add_floor():
	var scene = load("res://scenes/player/normal_floor_1.tscn")
	var scene_instance = scene.instantiate()
	floors.append(scene_instance)
	#print(get_tree().get_nodes_in_group("Floors").size())
	call_deferred("add_sibling", scene_instance)

# DETECCIÓN DE COLISIONES EN LOS PISOS
func detect_collisions():
	if len(floors) > 0:
		for i in range(len(floors)):
			if floors[i].collision_detected:
				return true
	return false
