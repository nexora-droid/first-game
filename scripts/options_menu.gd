extends Control




signal toggle_cutscene()
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_check_box_button_down() -> void:
	emit_signal("toggle_cutscene")
