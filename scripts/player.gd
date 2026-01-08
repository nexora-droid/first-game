extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var interact_shape := $Direction/ActionableFinder/CollisionShape2D
@onready var interact_x: float = interact_shape.position.x
var heaven_portal: Node = null
@onready var camera_limit: Node2D = $"../CameraLimit"
var options_menu: Node = null
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h=false
		interact_shape.position.x = interact_x
	elif direction < 0:
		animated_sprite.flip_h=true
		interact_shape.position.x = -interact_x
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("default")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var actionables = actionable_finder.get_overlapping_areas()
	var label: Label = null
	if get_parent().has_node("Labels/TalkPrompt"):
		label = get_parent().get_node("Labels/TalkPrompt") as Label
		if label:
			label.visible = actionables.size() > 0
func _ready() -> void:
	camera_2d.limit_bottom = 125
	heaven_portal = get_parent().get_node("HeavenPortal")
	if heaven_portal:
		heaven_portal.connect("entered_portal", Callable(self, "_on_portal_entered"))
	camera_limit.connect("change_limit", Callable(self, "_change_camera_limit"))

func _on_portal_entered():
	print("Entered Teleporter")
	
	set_physics_process(false)
	animated_sprite.stop()
	animated_sprite.play("cutscene")
	animation_player.play("go_to_heaven")
	while animation_player.is_playing():
		camera_2d.global_position = $Visual.global_position
		await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/heaven.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("keyboard_e"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _change_camera_limit()-> void:
	print("fire")
	camera_2d.limit_bottom = 95
