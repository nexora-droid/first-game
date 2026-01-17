extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

signal player_entered()

func _ready() -> void:
	pass

func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("Testing..")
	emit_signal("player_entered")
	print("Signal emitted")
