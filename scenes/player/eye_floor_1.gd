extends Floor

@onready var sprite_2d = $Sprite2D
@onready var input_axis = 1

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	
func shoot():
	print("PEW!!")
