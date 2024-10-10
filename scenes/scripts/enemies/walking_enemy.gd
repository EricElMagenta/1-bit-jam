extends CharacterBody2D

const SPEED = -100.0
var dir = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var fall_raycast = $FallRaycast
@onready var area_2d = $Area2D
@onready var sound_hit = $SoundHit


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	handle_animations()	
	if is_on_wall() || !fall_raycast.is_colliding(): handle_collisions()
		
	velocity.x = SPEED * dir	
	move_and_slide()

func handle_animations():
	animated_sprite_2d.play("walking")

# Al chocar con una pared se da vuelta el sprite, cambia su dirección, el raycast y el area 2d se voltean.
func handle_collisions():
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		dir *= -1
		fall_raycast.position.x *= -1
		area_2d.scale.x *= -1

# Si toca al jugador se reinicia un nivel y si le llega un disparo se borra.
func _on_area_player_entered(body):
	sound_hit.play()
	if body is Player:
		get_tree().reload_current_scene.call_deferred()
	
	if body is Fireball:
		queue_free()
