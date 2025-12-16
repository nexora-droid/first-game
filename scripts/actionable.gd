extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action():
	DialogueManager.show_dialogue_balloon_scene(load("res://dialogue/balloon.tscn"), dialogue_resource, dialogue_start)
