extends Node2D

const CLIENT_SCENE = preload("res://scene/Client.tscn")

func _ready() -> void:
	new_house()

func new_house() -> void:
	var node = CLIENT_SCENE.instantiate()
	node.color = Colors.get_random()
	add_child(node)
