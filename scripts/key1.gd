extends Area2D

var triggered := false

func _ready() -> void:
	show()
	$"../AnimatedSprite2D".hide()
	$"../../HideKeyBag".hide()
func _on_body_entered(body: Node2D) -> void:
	if triggered: return
	triggered = true
	$"../AnimatedSprite2D".show()
	$"../AnimatedSprite2D".play("default")
	$"../AnimatedSprite2D/AnimationPlayer".speed_scale = 1.5
	$"../AnimatedSprite2D/AnimationPlayer".play("ding")
	await get_tree().create_timer(2.66).timeout
	$"../AnimatedSprite2D".hide()
	$"../../HideKeyBag".show()
	hide()
