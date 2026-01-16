extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if $"../CameraLimit" == null:
		return
	elif $"../CameraLimit" != null:
		$"../CameraLimit".connect("change_limit", Callable(self, "_on_player_near"))

func _on_player_near() -> void:
	$AnimationPlayer.play("attack")
	await get_tree().create_timer(5).timeout
	$".".queue_free()
