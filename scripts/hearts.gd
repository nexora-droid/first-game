extends CanvasLayer


@onready var player: CharacterBody2D = %Player
@onready var hearts: Array = [
	$Heart1,
	$Heart2,
	$Heart3,
	$Heart4,
	$Heart5
]
const HEART_FULL := preload("res://assets/styles/heartfull.tres")
const HEART_EMPTY := preload("res://assets/styles/heartempty.tres")


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var ch = player.current_health
	update_hearts(ch)

func update_hearts(health: float) -> void:
	var full_hearts := int(ceil(health/20.0))
	for i in range(hearts.size()):
		if i < full_hearts:
			hearts[i].add_theme_stylebox_override("panel", HEART_FULL)
		else:
			hearts[i].add_theme_stylebox_override("panel", HEART_EMPTY)
