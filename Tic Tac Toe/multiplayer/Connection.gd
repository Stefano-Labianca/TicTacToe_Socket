extends Node

export var SOCKET_URL = "" # Server remoto
# export var SOCKET_URL = "ws://localhost:3000" # Server locale (Per usarlo bisogna avere NodeJS installato con i moduli Express, ws, TypeScript, nodemon)

const MAX_PLAYER: int = 2

var _client = WebSocketClient.new()
var game_node: Node
var wait_node: Control
var board_node: Node2D
var main_menu_node: Control
var win_node: Control


# Funzione usata per stabilire una connessione multiplayer
func start_multiplayer() -> void:
	_client.connect("connection_closed", self, "_on_connection_closed")
	_client.connect("connection_error", self, "_on_connection_error")
	_client.connect("connection_established", self, "_on_connection_established")
	_client.connect("data_received", self, "_on_data_received")

	var err = _client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Impossibile connettersi")
		set_process(false)

	game_node = get_tree().get_root().get_node("Game")
	wait_node = get_tree().get_root().get_node("Game/Waiting")
	board_node = get_tree().get_root().get_node("Game/Board")
	main_menu_node = get_tree().get_root().get_node("Game/MainMenu")
	win_node = get_tree().get_root().get_node("Game/Winner")


func _process(_delta: float) -> void:
	_client.poll() # Viene usata per controllare la ricezione dei dati


# Viene chiamata quando la connessione viene chiusa
func _on_connection_closed(was_clean = false) -> void:
	disconnect_multiplayer_signals()
	print("Connessione chiusa: ", was_clean)
	set_process(false)


# Viene chiamata quando la connessione viene stabilita
func _on_connection_established(protocol = ""):
	main_menu_node.get_parent().get_node("MainMenu/GameMessagge").text = ""
	print("Connessione stabilita con il protocollo: ", protocol)


func _on_connection_error() -> void:
	disconnect_multiplayer_signals()
	print("Errore")


# Viene chiamata quando ricevo dei dati dal server
func _on_data_received() -> void:
	var payload: Dictionary = JSON.parse(_client.get_peer(_client.TARGET_PEER_SERVER).get_packet().get_string_from_utf8()).result # Mi connetto al mio server con "_client.get_peer(1)" e ricevo dei dati

	if payload != null: # Verifico se il payload è null
		if payload.get("numPlayers") != null: # Verifico se il messaggio ricevuto contiene le informazioni sul numero di utenti connessi
			_verify_room(payload)

		if payload.get("chat") != null:	# Verifico se il messaggio ricevuto contiene le informazioni sulla chat
			var chat: RichTextLabel = board_node.get_node("Chat/ChatText")

			chat.push_color(Color("#6ebdea")) # Definisco il colore del testo ricevuto all'interno del nodo ChatText
			chat.add_text(payload.get("chat"))
			chat.newline()

		if payload.get("enemyInfo") != null:	# Verifico se il messaggio ricevuto contiene le informazioni sulle posizioni dello sprite
			var enemy_info: Array = $OnlineBoard.draw_enemy_sprite(payload)

			game_node.callv("update_multiplayer_board", [enemy_info[0], enemy_info[1]]) # Aggiorno la tabella del giocatore avversario
			board_node.get_node("Rounds").text = "Tocca a te"


		if payload.get("spriteType") != null: # Verifico se il messaggio ricevuto contiene le informazioni sul tipo di sprite assegnato al giocatore
			$OnlineBoard.set_sprite(payload)
			wait_node.visible = false
			main_menu_node.visible = false
			board_node.visible = true

			if payload.get("round") == "first":
				board_node.get_node("Rounds").text = "Tocca a te"
			elif payload.get("round") == "second":
				board_node.get_node("Rounds").text = "Tocca all'avversario"


		if payload.get("no_rematch") != null: # Verifico se il giocatore non vuole fare un'altra partita
			if payload.get("no_rematch"):
				_client.disconnect_from_host()
				disconnect_multiplayer_signals()
				game_node.callv("clear_game", [true])

				board_node.visible = false
				win_node.visible = false
				main_menu_node.visible = true

				var reason: Label = win_node.get_node("Reason")
				reason.text = ""


		if payload.get("gameover") != null: # Verifico se il messaggio ricevuto contiene le informazioni sulla vittoria o la sconfitta del giocatore
			game_node.callv("show_multiplayer_winner", [payload["gameover"]])


		if payload.get("rematch_request") != null:
			if payload.get("rematch_request"):
				var reason: Label = win_node.get_node("Reason")
				reason.text = "Il tuo avversario" + '\n' + "vuole risfidarti"

		if payload.get("server_rematch") != null: # Il server ha acconsentito il rematch
			var reason: Label = win_node.get_node("Reason")
			game_node.call("clear_game")
			win_node.visible = false
			reason.text = ""


# Viene chiamata quando invio dei dati dal server
#
# @params message: Dictionary --> Informazioni da inviare al server
func send(message: Dictionary) -> void:
	if message.get("enemy_sprite") != null:
		_client.get_peer(_client.TARGET_PEER_SERVER).put_packet(JSON.print(message).to_utf8()) # Invio dei dati al server
		board_node.get_node("Rounds").text = "Tocca all'avversario"

	elif message.get("chat") != null:
		_client.get_peer(_client.TARGET_PEER_SERVER).put_packet(JSON.print(message).to_utf8()) # Invio dei dati al server

	elif message.get("rematch") != null:
		_client.get_peer(_client.TARGET_PEER_SERVER).put_packet(JSON.print(message).to_utf8()) # Invio dei dati al server


# Funzione che controlla se ci sono abbastanza giocatori per poter iniziare la partita.
#
# @params payload: Dictionary --> Contiene il numero dei giocatori
func _verify_room(payload: Dictionary) -> void:
	main_menu_node = get_tree().get_root().get_node("Game/MainMenu")

	if payload.get("numPlayers") < MAX_PLAYER:
		main_menu_node.visible = false
		wait_node.visible = true

	if  payload.get("numPlayers") > MAX_PLAYER:
		_client.disconnect_from_host(1000, "sono di troppo :(") # Disconnetto il client
		disconnect_multiplayer_signals()


# Funzione che restituisce il client web socket.
#
# @return WebSocketClient --> Client web socket.
func get_web_socket() -> WebSocketClient:
	return _client


# Funzione che disconnette i segnali usati per il multiplayer
func disconnect_multiplayer_signals() -> void:
	if _client.is_connected("connection_established", self, "_on_connection_established"): # Controllo se i segnali sono connessi al nodo
		_client.disconnect("connection_closed", self, "_on_connection_closed")
		_client.disconnect("connection_error", self, "_on_connection_error")
		_client.disconnect("connection_established", self, "_on_connection_established")
		_client.disconnect("data_received", self, "_on_data_received")
