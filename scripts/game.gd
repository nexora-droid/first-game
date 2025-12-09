extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_manager: Node = %GameManager
	var hud: Node = $HUD
	game_manager.connect("score_changed", Callable(hud, "update_score"))
	
	
