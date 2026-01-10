extends Control


# Called when the node enters the scene tree for the first time.


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cave.tscn")
	print("Player Died")
	



func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
