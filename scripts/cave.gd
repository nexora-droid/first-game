extends Node2D

signal cave_loaded
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/Camera2D.limit_bottom = 127

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
