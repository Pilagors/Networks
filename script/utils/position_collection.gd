extends Node
class_name PositionCollection

var liste : Array[Vector2i]

func _init() -> void:
	self.liste = []


func get_possible_position(box_limit: Vector2, clamped_size: float) -> Vector2i:
	var new_position : Vector2i
	var failsafe : int = 50
	
	while failsafe > 0:
		var x := randi_range(box_limit.x / clamped_size, box_limit.y / clamped_size) * clamped_size
		var y := randi_range(box_limit.x / clamped_size, box_limit.y / clamped_size) * clamped_size
		new_position = Vector2i(x, y)
		
		if not liste.has(new_position):
			self.liste.append(new_position)
			return new_position
		
		failsafe -= 1

	return Vector2i(-1, -1)
