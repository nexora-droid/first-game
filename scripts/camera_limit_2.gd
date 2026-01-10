extends Node2D

signal change_limit_2
func _ready() -> void:
	print($StaticBody2D, "TYPE = ", $StaticBody2D.get_class())
	$StaticBody2D.connect("body_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(_body) -> void:
	emit_signal("change_limit_2")
