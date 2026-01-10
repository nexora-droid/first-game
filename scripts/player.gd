extends CharacterBody2D

var SPEED := 130.0
const JUMP_VELOCITY = -300.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var interact_shape := $Direction/ActionableFinder/CollisionShape2D
@onready var interact_x: float = interact_shape.position.x
@onready var camera_limit_2: Node2D = $"../CameraLimit2"
@onready var camera_limit: Node2D = $"../CameraLimit"
@onready var hud: CanvasLayer = $"../HUD"

var cave_pass: Node = null
var heaven_portal: Node = null
var camera_limit1_fired: bool = false
var camera_limit2_fired: bool = false
var options_menu: Node = null
var isHurt: bool

# Spell Bools:
var shapeA_casted := false
var shapeBS_casted := false
var shapeBT_casted := false
var shapeO_casted := false
var shapeS_casted := false
var shapeT_casted := false

@export var max_health := 100
@export var current_health: int = max_health

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
			
	#if !isHurt:
		#for area in DamageBox.get_overlapping_areas():
			#if area.is_in_group("DamageBox"):
				#damage(20)
				#print("-20")
func _ready() -> void:
	camera_2d.limit_bottom = 390
	heaven_portal = get_parent().get_node("HeavenPortal")
	if heaven_portal == null:
		pass
	elif heaven_portal != null:
		heaven_portal.connect("entered_portal", Callable(self, "_on_portal_entered"))
	if camera_limit == null:
		pass
	elif camera_limit != null:
		camera_limit.connect("change_limit", Callable(self, "_change_camera_limit"))
	if camera_limit_2 == null:
		pass
	elif camera_limit_2 != null:
		camera_limit_2.connect("change_limit_2", Callable(self, "_change_camera_limit_2"))
	cave_pass = get_parent().get_node("CavePass")
	if cave_pass != null:
		cave_pass.connect("player_entered", Callable(self, "_on_cave_pass"))
	elif cave_pass == null:
		pass
	hud.connect("shape_arrow", Callable(self, "on_shape_arrow"))
	hud.connect("shape_badstar", Callable(self, "on_shape_badstar"))
	hud.connect("shape_badtriangle", Callable(self, "on_shape_badtriangle"))
	hud.connect("shape_other", Callable(self, "on_shape_other"))
	hud.connect("shape_star", Callable(self, "on_shape_star"))
	hud.connect("shape_triangle", Callable(self, "on_shape_triangle"))
	
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
	if camera_limit1_fired:
		camera_2d.limit_bottom = 125
		camera_limit1_fired = false
		return
	print("fire")
	camera_2d.limit_bottom = 95
	camera_limit1_fired = true
func _change_camera_limit_2()-> void:
	if camera_limit2_fired:
		camera_2d.limit_bottom = 125
		camera_limit2_fired = false
		return
	print("fire")
	camera_2d.limit_bottom = 400
	camera_limit2_fired = true
func _on_cave_pass() -> void:
	print("Entered caver")
	set_physics_process(false)
	animated_sprite.stop()
	get_tree().change_scene_to_file("res://scenes/cave.tscn")
func damage(amount):
	if !isHurt:
		if current_health <= amount:
			collision_shape_2d.queue_free()
			Engine.time_scale = 0.8
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://scenes/cave_death.tscn")
			Engine.time_scale = 1
		else:
			current_health -= amount
			isHurt = true
			await get_tree().create_timer(0.5).timeout
			isHurt = false
			Engine.time_scale = 1
func _on_damage_box_2_hit_player() -> void:
	damage(20)
func on_shape_arrow() -> void:
	SPEED = 200
	await get_tree().create_timer(10, false).timeout
	SPEED = 130
	
