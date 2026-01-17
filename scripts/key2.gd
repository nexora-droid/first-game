extends Area2D

var triggered := false
func _ready() -> void:
	if State.k2g == true:
		$"../../HideKey2".show()
	else:
		show()
		$"../AnimatedSprite2D".hide()
		$"../../HideKey2".hide()
func _on_body_entered(body: Node2D) -> void:
	if triggered or State.k2g == true: 
		return
	if body.is_in_group("player"):
		State.keys += 1
		State.k2g = true
		triggered = true
		$"../AnimatedSprite2D".show()
		$"../AnimatedSprite2D".play("default")
		$"../AnimatedSprite2D/AnimationPlayer".speed_scale = 1.5
		$"../AnimatedSprite2D/AnimationPlayer".play("dingkey2")
		await get_tree().create_timer(2.66).timeout
		$"../AnimatedSprite2D".hide()
		$"../../HideKey2".show()
		hide()
