# GAME MANAGER SAVE CODE (To be used in the future)
#extends Node
#
#
#signal score_changed(new_score)
#var score = 0
#const save_path := "user://score.save"
#
#func _ready() -> void:
	#load_score()
#
#
#func save_score() -> void:
	#var file = FileAccess.open(save_path, FileAccess.WRITE)
	#var json_body = JSON.stringify({"score": score})
	#file.store_line(json_body)
	#file.close()
#
#func load_score() -> void:
	#if not FileAccess.file_exists(save_path):
		#return
	#var file = FileAccess.open(save_path, FileAccess.READ)
	#var line = file.get_line()
	#file.close()
	#var data = JSON.parse_string(line)
	#if typeof(data) == TYPE_DICTIONARY and data.has("score"):
		#score = data["score"]
		#emit_signal("score_changed", score)
#func add_point():
	#score += 1
	#save_score()
	#emit_signal("score_changed", score)
#
#
#func _notification(what: int) -> void:
	#if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#save_score()


extends Node


@onready var timer: Timer = $Timer

signal score_changed(new_score)
var score = 0

var levelsave_path := "user://level.save"
func _ready() -> void:
	var file = FileAccess.open(levelsave_path, FileAccess.WRITE)
	var json_body = JSON.stringify({"level": "heaven"})
	file.store_line(json_body)
	file.close()


func add_point():
	score += 1
	emit_signal("score_changed", score)
