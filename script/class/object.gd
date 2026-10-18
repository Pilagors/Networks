extends Node2D
class_name ConnectedObject

@export var max_connections : int = 1
@export var nb_connections : int
@export var connected_objects : Array[ConnectedObject]
@export var color : Color

@onready var body_2d: StaticBody2D = $Body
@onready var collision_2d: CollisionShape2D = $Body/Collision
@onready var mesh_2d: MeshInstance2D = $Body/Mesh

func _ready() -> void:
	mesh_2d.modulate = color

func connect_object(to_connect: ConnectedObject) -> bool:
	var res_self := _add_object(to_connect)
	var res_to_connect := to_connect._add_object(self)
	
	if !res_self && res_to_connect:
		to_connect._failsafe()
	
	if !res_to_connect && res_self:
		_failsafe()
	
	return res_self && res_to_connect


func _add_object(to_connect: ConnectedObject) -> bool:
	if (connected_objects.size() == max_connections):
		return false
		
	if to_connect == null:
		return false
		
	if connected_objects.find(to_connect) != -1:
		return false
	
	connected_objects.append(to_connect)
	return true

func _failsafe() -> ConnectedObject:
	return connected_objects.pop_back()

#region body
func _on_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			print("placeholder")
#endregion
