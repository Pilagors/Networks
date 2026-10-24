extends PathFollow2D
class_name Packet

@export var TTL: int = 5
@export var SPEED: float = 0.5;
@export var DEST: ConnectedObject;
@export var SRC: ConnectedObject;
@export var DIRECTION: int = 1;

func set_destination(obj: ConnectedObject) -> void:
	DEST = obj;
	
func set_source(obj: ConnectedObject) -> void:
	SRC = obj
	SRC.add_packet(self)

func ttl_decrement() -> void:
	TTL -= 1
	
	if position.distance_to(DEST.position) < 0.1:
		queue_free()
		SRC.remove_packet(self)
	
	if TTL == 0:
		queue_free()

func _ready() -> void:
	progress_ratio = 1.0 if DIRECTION == -1 else 0.0

func _process(delta: float) -> void:	
	var current_speed : float = SPEED * delta;

	if DIRECTION == 1:
		if progress_ratio + current_speed >= 1.0:
			ttl_decrement()
			return
		
		progress_ratio += current_speed
		
	elif DIRECTION == -1:
		if progress_ratio - current_speed <= 0.0:
			ttl_decrement()
			return
		
		progress_ratio -= current_speed
