extends Node2D

const CLIENT_SCENE = preload("res://scene/Client.tscn")
const CONNECTION_SCENE = preload("res://scene/Connection.tscn")
const PACKET_SCENE = preload("res://scene/Packet.tscn")

func _ready() -> void:
	# tests
	var client1 : Client = new_client(100, 0)
	var client2 : Client = new_client(0, 100)
	client2.set_packet_delay(0.006)
	
	var _connection : Connection = new_connection(client1, client2)

func new_client(x: int, y: int) -> ConnectedObject:
	var client : ConnectedObject = CLIENT_SCENE.instantiate()
	client.set_object_color(Colors.get_random_color())
	
	client.position = Vector2i(x, y)
	add_child(client)
	
	return client
	
func new_connection(a: ConnectedObject, b: ConnectedObject) -> Connection:
	var connection : Connection = a.connect_object(b)
	
	add_child(connection)
	
	return connection
