extends CharacterBody2D

var SPEED := 130.0
const JUMP_VELOCITY = -300.0
# self vars
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
# heaven vars
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var interact_shape := $Direction/ActionableFinder/CollisionShape2D
@onready var interact_x: float = interact_shape.position.x
# cave vars
@onready var camera_limit_2: Node2D = $"../CameraLimit2"
@onready var camera_limit: Node2D = $"../CameraLimit"
@onready var hud: CanvasLayer = $"../HUD"
# general vars
var cave_pass: Node = null
var heaven_portal: Node = null
var camera_limit1_fired: bool = false
var camera_limit2_fired: bool = false
var options_menu: Node = null
var isHurt: bool
var isImmune: bool = false

# Spell Bools:
var shapeA_casted := false
var shapeBS_casted := false
var shapeBT_casted := false
var shapeO_casted := false
var shapeS_casted := false
var shapeT_casted := false

@export var max_health := 100
@export var current_health: int = max_health

var levelsave_path := "user://level.save"
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		var particles_instance = $JumpParticles.duplicate()
		get_parent().add_child(particles_instance)
		particles_instance.global_position = global_position
		particles_instance.restart()
		
		
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
	cave_pass = get_parent().get_node("CavePass")
	if cave_pass != null:
		cave_pass.connect("player_entered", Callable(self, "_on_cave_pass"))
	elif cave_pass == null:
		pass
	load_level()
func _on_portal_entered():
	print("Entered Teleporter")
	set_physics_process(false)
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
#func damage(amount):
	#if !isHurt:
		#if current_health <= amount:
			#collision_shape_2d.queue_free()
			#Engine.time_scale = 0.8
			#await get_tree().create_timer(1).timeout
			#get_tree().change_scene_to_file("res://scenes/cave_death.tscn")
			#Engine.time_scale = 1
		#elif current_health >= amount:
			#current_health -= amount
			#isHurt = true
			#await get_tree().create_timer(0.5).timeout
			#isHurt = false
			#Engine.time_scale = 1
func _on_damage_box_2_hit_player() -> void:
	if isImmune == false:
		if !isHurt:
			if current_health <= 20:
				collision_shape_2d.queue_free()
				Engine.time_scale = 0.8
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_file("res://scenes/cave_death.tscn")
				Engine.time_scale = 1
			elif current_health >= 20:
				$HurtParticles.restart()
				current_health -= 20
				isHurt = true
				await get_tree().create_timer(0.5).timeout
				isHurt = false
				Engine.time_scale = 1
			print("negative 20 health")
	print("current health" + String.num(current_health))
func on_shape_arrow() -> void:
	SPEED = 300
	await get_tree().create_timer(10, false).timeout
	SPEED = 130

func on_shape_star() -> void:
	isImmune = true
	await get_tree().create_timer(5, false).timeout
	isImmune = false

# What you see below is an unnecessary bunch of code meant to identify what level game is on to 
# deal with my game's 15+ errors where a bunch of vars aren't being found which are in different levels

func load_level():
	if not FileAccess.file_exists(levelsave_path):
		return
	var file = FileAccess.open(levelsave_path, FileAccess.READ)
	var contents = file.get_line()
	file.close()
	var data = JSON.parse_string(contents)
	if typeof(data) == TYPE_DICTIONARY and data.has("level"):
		if data["level"] == "cave":
			camera_limit.connect("change_limit", Callable(self, "_change_camera_limit"))
			camera_limit_2.connect("change_limit_2", Callable(self, "_change_camera_limit_2"))
			hud.connect("shape_arrow", Callable(self, "on_shape_arrow"))
			hud.connect("shape_badstar", Callable(self, "on_shape_badstar"))
			hud.connect("shape_badtriangle", Callable(self, "on_shape_badtriangle"))
			hud.connect("shape_other", Callable(self, "on_shape_other"))
			hud.connect("shape_star", Callable(self, "on_shape_star"))
			hud.connect("shape_triangle", Callable(self, "on_shape_triangle"))


func _on_hud_shape_star() -> void:
	print("go12")
	isImmune = true
	await get_tree().create_timer(5, false).timeout
	isImmune = false
	print("go214")


func _on_area_2d_body_entered(body: Node2D) -> void: #room1
	if body.is_in_group("player"):
		await get_tree().create_timer(10).timeout
		body.get_node("CollisionShape2D").queue_free()
		await get_tree().create_timer(0.5).timeout
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://scenes/cave_death.tscn")


func _on_room_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(10).timeout
		body.get_node("CollisionShape2D").queue_free()
		await get_tree().create_timer(0.5).timeout
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://scenes/cave_death.tscn")


func _on_room_3_body_entered(body: Node2D) -> void:
	pass # set position to new rooms


func _on_room_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(10).timeout
		body.get_node("CollisionShape2D").queue_free()
		await get_tree().create_timer(0.5).timeout
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://scenes/cave_death.tscn")


func _on_room_5_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(10).timeout
		body.get_node("CollisionShape2D").queue_free()
		await get_tree().create_timer(0.5).timeout
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://scenes/cave_death.tscn")


func _on_door_1_pressed() -> void: # door button
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_int = rng.randi_range(1, 5)
	if rand_int == 1:
		position = Vector2(2763, -125)
	if rand_int == 2:
		position = Vector2(3306, -125)
	if rand_int == 3:
		position = Vector2(4062, -338)
	if rand_int == 4:
		position = Vector2(4684, -213)
	if rand_int == 5:
		position = Vector2(5283, -225)
		
