extends CharacterBody2D
class_name Fireball

@export var speed = 400
@onready var timer = $Timer
@onready var sound_shoot = $SoundShoot

var dir : float = 1
var spawn_pos : Vector2

# Spawnea en las coordenadas introducidas e inicia el Timer
func _ready():
	global_position = spawn_pos
	timer.start()
	sound_shoot.play()

# Viaja hasta chocar con algo, entonces desaparece
func _physics_process(delta):

	velocity = Vector2(speed * dir, 0)
	move_and_collide(velocity * delta)
	

# Desaparece si se acaba el Timer
func _on_timer_timeout():
	queue_free()

# Desaparece si choca con algo
func collision_detected():
	queue_free()
	
