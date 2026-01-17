extends Area2D

var triggered := false
func _ready() -> void:
	if State.k4g == true:
		$"../../HideKey4".show()
	else:
		show()
		$"../AnimatedSprite2D".hide()
		$"../../HideKey4".hide()
func _on_body_entered(body: Node2D) -> void:
	if triggered or State.k4g: 
		return
	if body.is_in_group("player"):
		State.keys += 1
		triggered = true
		State.k3g = true
		$"../AnimatedSprite2D".show()
		$"../AnimatedSprite2D".play("default")
		$"../AnimatedSprite2D/AnimationPlayer".speed_scale = 1.5
		$"../AnimatedSprite2D/AnimationPlayer".play("dingkey4")
		print("yessir playing now")
		await get_tree().create_timer(2.66).timeout
		$"../AnimatedSprite2D".hide()
		$"../../HideKey4".show()
		hide()
