extends Node2D
class_name ConnectedObject

const CONNECTION_SCENE = preload("res://scene/Connection.tscn")

@export var max_connections : int = 1
@export var nb_connections : int
@export var connected_objects : Array[ConnectedObject]
@export var all_connections : Array[Connection]
@export var all_packets : Array[Packet]
@export var color : Color

@onready var body_2d: StaticBody2D = $Body
@onready var collision_2d: CollisionShape2D = $Body/Collision
@onready var mesh_2d: MeshInstance2D = $Body/Mesh

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	mesh_2d.modulate = color

func add_packet(packet: Packet) -> void:
	all_packets.append(packet)
	
func remove_packet(packet: Packet) -> void:
	var where : int = all_packets.find(packet)
	all_packets.remove_at(where)

func connect_object(to_connect: ConnectedObject) -> Connection:
	var res_self := _add_object(to_connect)
	var res_to_connect := to_connect._add_object(self)
	
	if !res_self && res_to_connect:
		to_connect._failsafe()
		return null # retourner la connection qui contient les deux objets (self et to_connect)
	
	if !res_to_connect && res_self:
		_failsafe()
		return null # retourner la connection qui contient les deux objets (self et to_connect)
		
	# les deux sont pas connectés
	var connection : Connection = CONNECTION_SCENE.instantiate()
	connection.object_a = self
	connection.object_b = to_connect
	
	self.add_connection(connection)
	to_connect.add_connection(connection)
	
	return connection
	

func select_random_destination() -> Connection:
	print(connected_objects.size())
	var selected_object : ConnectedObject = connected_objects.pick_random()
	print("j'ai choisi d'envoyer à ", selected_object)
	for current_connection in all_connections:
		if current_connection.get_other_object(selected_object) == self:
			return current_connection
			
	return null

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
	
func set_object_color(c: Color) -> void:
	color = c
	
func add_connection(connection: Connection) -> void:
	if all_connections.find(connection) != -1:
		print("you")
		return

	all_connections.append(connection)

#region body
func _on_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			print("placeholder")
#endregion
