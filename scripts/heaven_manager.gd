extends Node



@onready var timer: Timer = $Timer

signal score_changed(new_score)
var score = 0

func add_point():
	score += 1
	emit_signal("score_changed", score)
