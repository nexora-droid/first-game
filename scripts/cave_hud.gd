extends CanvasLayer

var isVisible := false
signal panel_visible	
@onready var casting: Panel = $Casting

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift"):
		isVisible = not isVisible
		if isVisible == true:
			emit_signal("panel_visible")
	visible = isVisible

signal shape_arrow
signal shape_badstar
signal shape_badtriangle
signal shape_other
signal shape_star
signal shape_triangle


func _ready() -> void:
	casting.connect("shape_arrow", Callable(self, "on_shape_arrow"))
	casting.connect("shape_badstar", Callable(self, "on_shape_badstar"))
	casting.connect("shape_badtriangle", Callable(self, "on_shape_badtriangle"))
	casting.connect("shape_other", Callable(self, "on_shape_other"))
	casting.connect("shape_star", Callable(self, "on_shape_star"))
	casting.connect("shape_triangle", Callable(self, "on_shape_triangle"))

func on_shape_arrow():
	emit_signal("shape_arrow")
	
func on_shape_badstar():
	emit_signal("shape_badstar")

func on_shape_badtriangle():
	emit_signal("shape_badtriangle")

func on_shape_other():
	emit_signal("shape_other")

func on_shape_star():
	emit_signal("shape_star")
	
func on_shape_triangle():
	emit_signal("shape_triangle")
