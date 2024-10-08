extends CharacterBody2D

const SPEED = -220.0
var dir = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var area_2d = $Area2D

func _physics_process(delta):
	handle_animation()
	if is_on_wall(): handle_collision()
	
	velocity.x = SPEED * dir
	move_and_slide()

func handle_animation():
	animated_sprite_2d.play("flying")

func handle_collision():
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		dir *= -1
		area_2d.scale.x *= -1

func _on_area_2d_body_entered(body):
	if body is Player:
		get_tree().reload_current_scene.call_deferred()
	
	if body is Fireball:
		queue_free()
