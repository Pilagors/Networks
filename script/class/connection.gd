extends Node2D
class_name Connection

@export var object_a : ConnectedObject
@export var object_b : ConnectedObject

@onready var path: Path2D = $Path
@onready var line: Line2D = $Line

var packets : Array[Packet] = []

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	update_connection()
	
func _draw() -> void:
	update_connection()
	
func set_connection(a: ConnectedObject, b: ConnectedObject) -> void:
	object_a = a
	object_b = b
	
	update_connection()

func get_other_object(this: ConnectedObject) -> ConnectedObject:
	if object_a != this:
		return object_a
	else:
		return object_b

func update_connection() -> void:
	if object_a == null && object_b == null:
		return
	
	var a := to_local(object_a.global_position)
	var b := to_local(object_b.global_position)
	
	var middle1 := Vector2((b.x+a.x)/2, a.y)
	var middle2 := Vector2((b.x+a.x)/2, b.y)
	
	path.curve.clear_points()
	path.curve.add_point(a)
	path.curve.add_point(middle1)
	path.curve.add_point(middle2)
	path.curve.add_point(b)
	
	line.clear_points()
	line.add_point(a)
	line.add_point(middle1)
	line.add_point(middle2)
	line.add_point(b)
	
	queue_redraw()

func send_packet(packet: Packet) -> void:
	if packet == null:
		return
	
	var message_direction = get_message_direction(packet)
	packet.DIRECTION = message_direction
	packets.append(packet)
	
	path.add_child(packet)
	print("paquet envoyé!")
	
func get_message_direction(paquet : Packet) -> int:
	if object_a == paquet.DEST:
		return -1
	elif object_b == paquet.DEST:
		return 1
	else:
		return 0
