extends Area2D


@onready var timer = $Timer
func _on_body_entered(body):
	Engine.time_scale=0.8
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale=1
	get_tree().change_scene_to_file("res://scenes/cave_death.tscn")
