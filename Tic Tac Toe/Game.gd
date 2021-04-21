extends Node

const TIME: float = 7.5

var difficulty: int = 0
var end: bool = false
var game_board: Array = [
	[-1, -1, -1],
	[-1, -1, -1],
	[-1, -1, -1]
]


func _input(event: InputEvent) -> void:
	if end and event.is_action_pressed("restart"): # Quando uno dei due giocatori vuole fare un'altra partita

		if self.difficulty == 0:
			if $Winner/Reason.text == "":
				$Multiplayer.send({"rematch": true, "player": $Multiplayer/OnlineBoard.player_sprite}) # Richiesta di rematch
				$Winner/Reason.text = "Richiesta inviata"

			else:
				if end and event.is_action_pressed("restart"):
					var regex: RegEx = RegEx.new()

					if regex.compile("tornare al menu") == OK:
						if not regex.search($Winner/RestartLabel.text):
							$Multiplayer.send({"rematch": true, "player": $Multiplayer/OnlineBoard.player_sprite}) # Richiesta di rematch

						else:
							var socket: WebSocketClient = $Multiplayer.get_web_socket()

							$Multiplayer.disconnect_multiplayer_signals()
							socket.disconnect_from_host()

							$Winner.visible = false
							$Board.visible = false
							$MainMenu.visible = true
							$Board/Chat/ChatText.clear()

							clear_game()
		else:
			clear_game()
			$Winner.visible = false

	if end and event.is_action_pressed("ui_cancel"): # Quando uno dei due giocatori non vuole fare un'altra partita
		if self.difficulty == 0:
			var socket: WebSocketClient = $Multiplayer.get_web_socket()

			$Multiplayer.send({"rematch": false, "player": $Multiplayer/OnlineBoard.player_sprite})

			$Multiplayer.disconnect_multiplayer_signals()
			socket.disconnect_from_host()

			$Winner.visible = false
			$Board.visible = false
			$MainMenu.visible = true
			$Board/Chat/ChatText.clear()

			clear_game()


# Funzione usata per ricreare la sessione di gioco, in caso si ricerchi il rematch.
# Il parametro 'is_left' serve per capire se
#
# @params is_left: bool --> Controlla se un giocatore è uscito
func clear_game(is_left: bool = false) -> void:

	if is_left:
		$MainMenu/GameMessagge.visible = true
		$MainMenu/GameMessagge.text = "L'avversario ha abbandonato"
		$MainMenu/GameMessagge/Timer.start(TIME)
		$MainMenu/GameMessagge/Timer.one_shot = true


	end = false
	game_board = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]]
	$AIManager.board = game_board
	$Multiplayer/OnlineBoard.turno = 0
	$Winner/Reason.text = ""

	var o_texture_list: Array = get_tree().get_nodes_in_group("o_texture_group")
	var x_texture_list: Array = get_tree().get_nodes_in_group("x_texture_group")

	# Ripulisco la tabella di gioco
	for o_texture in o_texture_list:
		o_texture.queue_free()

	for x_texture in x_texture_list:
		x_texture.queue_free()


# Funzione usata per aggiornare lo stato logico della tabella di gioco. La tabella viene
# vista come una matrice 3x3, contenente solamente il valore -1 per indicare lo stato di "vuoto".
# Per il giocatore che possiede i cerchi, verrà inserito 0, per chi possiede le croci 1.
#
# Esempio:
#	[-1, 0, 1]
#	[0, -1, -1]
#	[-1, -1, 1]
#
# @params dict: Dictionary --> Contiene la mappa della posizione logica e reale delle celle
# @params position: Vector2 --> Posizione dello sprite
# @params id: String --> Identifica l'AI e il giocatore
func update_board(dict: Dictionary, position: Vector2, id: String) -> void:
	if id == "Player":
		_update_for_player(dict, position)
	elif id == "AI":
		_update_for_ai(position)


# Funzione usata per aggiorare la posizione dello sprite del giocatore
# all'interno della griglia di gioco logica.
#
# @params dict: Dictionary --> Contiene la mappa della posizione logica e reale delle celle
# @params position: Vector2 --> Posizione dello sprite
func _update_for_player(dict: Dictionary, position: Vector2) -> void:
	var player_key_vector: Vector2 = get_key(dict, position)
	game_board[player_key_vector.y][player_key_vector.x] = $AIManager.PLAYER_VALUE
	_print_board()


# Funzione usata per aggiorare la posizione dello sprite dell'AI
# all'interno della griglia di gioco logica.
#
# @params ai_key_vector: Vector2 --> Posizione dello sprite nella matrice
func _update_for_ai(ai_key_vector: Vector2)  -> void:
	game_board[ai_key_vector.y][ai_key_vector.x] = $AIManager.AI_VALUE
	_print_board()


# Funzione usata per restituire la chiave di un dizionario, sotto forma di
# Vector2, partendo dal valore di essa. In caso non ci dovvesse essere
# la mappatura, resitutisce 'Vector2(-1, -1)'.
#
# @params dict: Dictionary --> Dizionario da controllare
# @params value: Vector2 --> Valore associato alla chiave da ricercare
#
# @returns Vector2 --> Chiave associata al valore
func get_key(dict: Dictionary, value: Vector2) -> Vector2:
	for key in dict:
		if dict[key] == value:
			return key

	return $AIManager.NULL_VECTOR


# Funzione usata per controllare se la posizione contenuta nel parametro 'generated_position'
# è già stata occupata da un altro sprite. Restituisce true se una cella è già stata
# riempita, altrimenti resituisce false.
#
# @params generated_position: Vector2 --> Posizione dell'AI
#
# @returns bool --> esito ricerca
func is_cell_full(generated_position: Vector2) -> bool:
	var pos: Vector2 = generated_position
	var value: int = game_board[pos.y][pos.x]

	if value == $AIManager.EMPTY_VALUE:
		return false
	else:
		return true


# Funzione che controlla se ci sono spazi vuoti nella griglia di gioco, restituendo
# false se ci sono altri spazi vuoti, in caso contrario true.
#
# @returns bool --> esito ricerca
func has_last_empty_cell() -> bool:
	for y in game_board:
		if y.find($AIManager.EMPTY_VALUE) != $AIManager.EMPTY_VALUE:
			return false
	return true


# Funzione usata per controllare chi è il vincitore della partita.
#
# @returns Array --> Array con i dati di chi ha vinto
func is_winner() -> Array:
	var winner_stats: Array = []

	winner_stats = _horizontal_win()
	if winner_stats[0]:
		print(winner_stats)
		end = true

	else:
		winner_stats = _vertical_win()
		if winner_stats[0]:
			print(winner_stats)
			end = true

		else:
			winner_stats = _diagonal_win()
			if winner_stats[0]:
				print(winner_stats)
				end = true

			else:
				winner_stats = _anti_diagonal_win()
				if winner_stats[0]:
					print(winner_stats)
					end = true

	return winner_stats


# Funzione usata per controllare se l'AI  o il giocatore vincono tramite
# il pattern 'orizzontale'.
#
# @returns Array --> Array con i dati di chi ha vinto
func _horizontal_win() -> Array:
	var winner: Array = [false, "None"]

	for y in range(game_board.size()):
		if game_board[y][0] == 0:
			if (game_board[y][1] == 0) and (game_board[y][2] == 0):
				winner[0] = true
				winner[1] = "Player"
				break

		elif game_board[y][0] == 1:
			if (game_board[y][1] == 1) and (game_board[y][2] == 1):
				winner[0] = true
				winner[1] = "AI"
				break

	return winner


# Funzione usata per controllare se l'AI  o il giocatore vincono tramite
# il pattern 'verticale'.
#
# @returns Array --> Array con i dati di chi ha vinto
func _vertical_win() -> Array:
	var winner: Array = [false, "None"]

	for x in range(game_board.size()):
		if game_board[0][x] == 0:
			if (game_board[1][x] == 0) and (game_board[2][x] == 0):
				winner[0] = true
				winner[1] = "Player"
				break

		elif game_board[0][x] == 1:
			if (game_board[1][x] == 1) and (game_board[2][x] == 1):
				winner[0] = true
				winner[1] = "AI"
				break

	return winner


# Funzione usata per controllare se l'AI  o il giocatore vincono tramite
# il pattern 'diagonale principale'.
#
# @returns Array --> Array con i dati di chi ha vinto
func _diagonal_win() -> Array:
	var winner: Array = [false, "None"]

	if (game_board[0][0] == 0) and (game_board[1][1] == 0) and (game_board[2][2] == 0):
		winner[0] = true
		winner[1] = "Player"

	if (game_board[0][0] == 1) and (game_board[1][1] == 1) and (game_board[2][2] == 1):
		winner[0] = true
		winner[1] = "AI"

	return winner


# Funzione usata per controllare se l'AI  o il giocatore vincono tramite
# il pattern 'diagonale secondaria'.
#
# @returns Array --> Array con i dati di chi ha vinto
func _anti_diagonal_win() -> Array:
	var winner: Array = [false, "None"]

	if (game_board[2][0] == 0) and (game_board[1][1] == 0) and (game_board[0][2] == 0):
		winner[0] = true
		winner[1] = "Player"

	if (game_board[2][0] == 1) and (game_board[1][1] == 1) and (game_board[0][2] == 1):
		winner[0] = true
		winner[1] = "AI"

	return winner


# Funzione usata pre mostrare a video il risultato della partita.
#
# @params winner: String --> Stato della partita
func show_winner(winner: String) -> void:
	if winner == "Player":
		$Winner/Message.text = "Hai vinto"
		$Winner.visible = true
	elif winner == "AI":
		$Winner/Message.text = "Hai perso"
		$Winner.visible = true
	elif winner == "None":
		$Winner/Message.text = "Pareggio"
		$Winner.visible = true
		end = true


# Funzione che aggiorna la griglia di gioco nel caso si partita multiplayer.
#
# @params pos: Vector2 --> Posizione cella premuta.
# @params sprite_type: String --> Sprite del giocatore.
func update_multiplayer_board(pos: Vector2, sprite_type: String) -> void:
	if sprite_type == $Multiplayer/OnlineBoard.SPRITE_DICT.O_S:
		game_board[pos.y][pos.x] = $AIManager.PLAYER_VALUE
	elif sprite_type == $Multiplayer/OnlineBoard.SPRITE_DICT.X_S:
		game_board[pos.y][pos.x] = $AIManager.AI_VALUE

	_print_board()


# Funzione usata per visualizzare lo stato dell'esito della partita.
#
# @params player_status: String --> Esito partita.
func show_multiplayer_winner(player_status: String) -> void:
	if player_status == "win":
		$Winner/Message.text = "Hai vinto"
		$Winner/RestartLabel.text = "Premi 'SPAZIO'" + '\n' + "per la rivincita o " + '\n' +  "'ESC' per uscire"
		$Winner.visible = true

	elif player_status == "lose":
		$Winner/Message.text = "Hai perso"
		$Winner/RestartLabel.text = "Premi 'SPAZIO'" + '\n' + "per la rivincita o " + '\n' +  "'ESC' per uscire"
		$Winner.visible = true

	elif player_status == "draw":
		$Winner/Message.text = "Pareggio"
		$Winner/RestartLabel.text = "Premi 'SPAZIO'" + '\n' + "per la rivincita o " + '\n' +  "'ESC' per uscire"
		$Winner.visible = true

	elif player_status == "enemy_quit":
		$Winner/Message.text = "Hai vinto"
		$Winner/Reason.text = "Il tuo avversario ha" +  "\n" + "abbandonato la partita"
		$Winner/RestartLabel.text = "Premi 'SPAZIO'" +  "\n" + "per tornare al menu"
		$Winner.visible = true

	end = true


# Stampa i dati contenuti nella tabella di gioco logica.
func _print_board() -> void:
	for x in range(game_board.size()):
		print(game_board[x])
	print()
