extends CharacterBody2D

@onready var schut_timer = $schut_timer
@onready var bullet = load("res://scenes/enemies/enemy_bullet2.tscn")
var can_shoot = true

func _ready():
	scale.x = -1

# Dispara una vez por segundo. Cuando dispara can_shoot se hace falso y empieza el timer
# para que can_shoot sea verdadero de nuevo
func _physics_process(_delta):
	if can_shoot: handle_shoot()

func handle_shoot():
	var bullet_instance = bullet.instantiate()
	bullet_instance.spawn_pos = global_position + Vector2(-20, 0)
	call_deferred("add_sibling", bullet_instance)
	
	can_shoot = false
	schut_timer.start()

func _on_schut_timer_timeout():
	can_shoot = true

func _on_area_fireball_entered(body):
	if body is Fireball:
		queue_free()
