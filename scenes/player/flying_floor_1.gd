extends Floor

@export var movement_data : PlayerMovementData

# Al crearse se habilita el salto en el aire. Mientras mas pisos alados tenga el jugador, más saltos en el aire puede dar.
func _ready():
	movement_data.double_jump_acquired = true
	movement_data.air_jumps += 1
	movement_data.max_air_jumps += 1
