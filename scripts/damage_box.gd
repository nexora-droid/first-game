extends Area2D

signal hit_player
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		emit_signal("hit_player")
		print("ouch")
