extends Node2D

var is_skip_cutscene: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_manager: Node = %HeavenManager
	var hud: Node = $HUD
	game_manager.connect("score_changed", Callable(hud, "update_score"))
