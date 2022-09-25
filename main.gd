extends Node3D

var multiplayer_peer = ENetMultiplayerPeer.new()

@onready var menu = $Menu


func _on_join_pressed():
	var port = str($Menu/Port.text).to_int()
	multiplayer_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false


func _on_host_pressed():
	var port = str($Menu/Port.text).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	menu.visible = false
	add_player_character()


func add_player_character(id=1):
	var character = preload("res://player_character/player_character.tscn").instantiate()
	character.name = str(id)
	add_child(character)
	
