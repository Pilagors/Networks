extends ConnectedObject
class_name Client

const PACKET_SCENE = preload("res://scene/Packet.tscn")

@export var nb_requests_minute : float = 30.0

@onready var send_packet: Timer = $SendPacket
@onready var patience: Timer = $Patience

func _ready() -> void:
	set_packet_delay(nb_requests_minute)

func set_packet_delay(new_delay: float) -> void:
	nb_requests_minute = new_delay
	send_packet.wait_time = 60.0 / nb_requests_minute
	

func _on_send_packet_timeout() -> void:
	var dest : Connection = select_random_destination()
	
	if dest != null:
		var packet : Packet = PACKET_SCENE.instantiate()
		packet.set_destination(dest.get_other_object(self))
		packet.set_source(self)
		dest.send_packet(packet)
		patience_deactivation()
	
	if dest == null:
		patience_activation()

func patience_activation() -> void:
	if patience.is_stopped():
		patience.start()

func patience_deactivation() -> void:
	if !patience.is_stopped():
		patience.stop()

func _on_patience_timeout() -> void:
	get_tree().quit()
