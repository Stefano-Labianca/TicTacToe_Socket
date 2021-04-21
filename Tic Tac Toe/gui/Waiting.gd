extends Control


# Funzione che fa uscire dalla coda il giocatore in attesa di un avversario
func _on_Back_pressed() -> void:
	var wait_node: Control = get_tree().get_root().get_node("Game/Waiting")
	var main_menu_node: Control = get_tree().get_root().get_node("Game/MainMenu")
	var multiplayer_node: Node = get_tree().get_root().get_node("Game/Multiplayer")

	var client: WebSocketClient = multiplayer_node.call("get_web_socket")
	var sound = main_menu_node.callv("create_audio_stream", [$Back.rect_position])

	get_parent().add_child(sound)
	sound.play(0)

	wait_node.visible = false
	main_menu_node.visible = true

	multiplayer_node.call("disconnect_multiplayer_signals")
	client.disconnect_from_host(1000, "esco dalla coda")
