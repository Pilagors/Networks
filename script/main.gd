extends Node2D

const CLIENT_SCENE = preload("res://scene/Client.tscn")
const SERVER_SCENE = preload("res://scene/Server.tscn")
const CONNECTION_SCENE = preload("res://scene/Connection.tscn")
const PACKET_SCENE = preload("res://scene/Packet.tscn")
const CLIENT_SIZE : float = 20.0
const SERVER_SIZE : float = 40.0

var color_placed : Array[Color] = []
var objects_selected : ObjectCollection = ObjectCollection.new(2)
var objects_position : PositionCollection = PositionCollection.new()

var previzu_line : Line2D = null

func _ready() -> void:
	new_server()
	new_client()
	
func _process(_delta: float) -> void:
	#region mouse
	if previzu_line:
		previzu_line.set_point_position(1, previzu_line.to_local(get_global_mouse_position()))
	#endregion

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var object : ConnectedObject = get_object_under_mouse()
			
			if event.pressed:
				objects_selected.add_object(object)
				
				previzu_line = Line2D.new()
				previzu_line.width = 3.0
				previzu_line.default_color = Color.CYAN
				
				add_child(previzu_line)
				
				previzu_line.add_point(previzu_line.to_local(object.global_position if object != null else get_global_mouse_position()))
				previzu_line.add_point(previzu_line.to_local(get_global_mouse_position()))
			
			if not event.pressed:
				if previzu_line:
					previzu_line.queue_free()
					previzu_line = null
				
				print(object == null)
				if object != null && !objects_selected.contains_object(object):
					objects_selected.add_object(object)
					new_connection(objects_selected.get_object(0), objects_selected.get_object(1))
				
				objects_selected.empty_list()


func new_client() -> ConnectedObject:
	var client : ConnectedObject = CLIENT_SCENE.instantiate()
	var box_limit := get_box_limit()

	if color_placed.is_empty():
		add_random_color()
	
	client.set_object_color(color_placed.pick_random())
	
	client.position = objects_position.get_possible_position(box_limit, CLIENT_SIZE)
	add_child(client)
	
	client.resize(CLIENT_SIZE)
	return client
	
func new_connection(a: ConnectedObject, b: ConnectedObject) -> Connection:
	var connection : Connection = a.connect_object(b)
	
	add_child(connection)
	
	return connection


func new_server() -> ConnectedObject:
	var server : ConnectedObject = SERVER_SCENE.instantiate()
	var box_limit := get_box_limit()
	
	if color_placed.is_empty():
		add_random_color()
		
	server.set_object_color(color_placed.pick_random())
	
	server.position = objects_position.get_possible_position(box_limit, SERVER_SIZE)
	add_child(server)
	
	server.resize(SERVER_SIZE)
	return server


func add_random_color() -> void:
	color_placed.append(Colors.get_random_color())
	
func get_object_under_mouse() -> ConnectedObject:
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var results := space_state.intersect_point(query)

	if results.size() > 0:
		var object : Node = results[0].collider
		if is_instance_of(object.get_parent(), ConnectedObject):
			return object.get_parent()

	return null


func get_box_limit() -> Vector2:
	var box_limit := Vector2(-10 * CLIENT_SIZE, 10 * CLIENT_SIZE)
	var x := randi_range(box_limit.x / CLIENT_SIZE, box_limit.y / CLIENT_SIZE) * CLIENT_SIZE
	var y := randi_range(box_limit.x / CLIENT_SIZE, box_limit.y / CLIENT_SIZE) * CLIENT_SIZE
	return Vector2(x, y)

func _on_new_random_client_timeout() -> void:
	var random_client = new_client()


func _on_new_random_color_timeout() -> void:
	add_random_color()


func _on_new_random_server_timeout() -> void:
	pass # Replace with function body.
