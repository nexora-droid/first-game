extends Area2D

@onready var slow_mo: Node2D = $".."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
signal damage_20
func _ready() -> void:
	print("loaded")
	
func _physics_process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("fireball"):
			Engine.time_scale = 0.3
			damage_20.emit()
			speed_reduce()
			
func speed_reduce() -> void:
	Engine.time_scale = 0.5
	print(0.5)
	await get_tree().create_timer(1).timeout
	Engine.time_scale = 0.8
	print(0.8)
	await get_tree().create_timer(1).timeout
	Engine.time_scale = 1
	print(1)
