extends CanvasLayer

var isVisible := false
signal panel_visible	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift"):
		isVisible = not isVisible
		if isVisible == true:
			emit_signal("panel_visible")
	visible = isVisible
