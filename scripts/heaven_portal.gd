extends Node2D

@onready var heaven_portal: Node2D = $"."
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

signal entered_portal()
func _ready() -> void:
	area_2d.connect("body_entered", Callable(self, "_on_area_entered"))
	
func _on_area_entered(_body):
	print("Entered Teleporter")
	emit_signal("entered_portal")
