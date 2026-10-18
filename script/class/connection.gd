extends Node2D
class_name Connection

@export var object_a : ConnectedObject
@export var object_b : ConnectedObject

@onready var path: Path2D = $Path
@onready var line: Line2D = $Line

func _ready() -> void:
	update_connection()
	
func _draw() -> void:
	update_connection()

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
