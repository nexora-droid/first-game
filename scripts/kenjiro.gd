extends StaticBody2D

@onready var kenjiro_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func face_player():
	if not player:
		return
	var dir = player.global_position.x-global_position.x
	kenjiro_sprite.flip_h = dir < 0
