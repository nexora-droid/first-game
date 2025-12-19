extends Node



@onready var timer: Timer = $Timer

signal score_changed(new_score)
var score = 0

func add_point():
	score += 1
	emit_signal("score_changed", score)
	if score == 39:
		get_tree().change_scene_to_file("res://scenes/finish_menu.tscn")
