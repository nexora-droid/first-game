extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Direction/ActionableFinder/CollisionShape2D
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var camera_2d: Camera2D = $Camera2D
var heaven_portal: Node = null
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
		collision_shape_2d.position.x = 5
		
	elif direction < 0:
		animated_sprite.flip_h=true
		collision_shape_2d.position.x = -5
	
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

func _ready() -> void:
	heaven_portal = get_parent().get_node("HeavenPortal")
	if heaven_portal:
		heaven_portal.connect("entered_portal", Callable(self, "_on_portal_entered"))

func _on_portal_entered():
	print("Entered Teleporter")
	set_physics_process(false)
	animated_sprite.stop()
	animated_sprite.play("cutscene")
	animation_player.play("go_to_heaven")
	while animation_player.is_playing():
		camera_2d.global_position = $Visual.global_position
		await get_tree().process_frame
	get_tree().create_timer(9)
	get_tree().change_scene_to_file("res://scenes/heaven.tscn")
