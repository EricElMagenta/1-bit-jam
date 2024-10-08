extends CharacterBody2D
class_name EnemyBullet

@onready var area_2d = $Area2D

var speed = -300.0
var dir : float = 1
var spawn_pos : Vector2

func _ready():
	global_position = spawn_pos

func _physics_process(delta):
	velocity = Vector2(speed * dir, 0)
	move_and_collide(velocity * delta)

func _on_player_entered(body):
	body.monitoring = true
	if body == Floor:
		get_tree().reload_current_scene.call_deferred()
