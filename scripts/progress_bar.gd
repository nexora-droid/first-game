extends ProgressBar

@onready var player: CharacterBody2D = $"../../Player"

func _ready() -> void:
	update()

func update() -> void:
	value = player.current_health * 100 / player.max_health
