extends Area2D



@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var heaven_manager: Node = %HeavenManager


func _on_body_entered(_body):
	heaven_manager.add_point()
	animation_player.play('pickup')
