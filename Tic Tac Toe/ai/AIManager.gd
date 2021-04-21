extends Node

const RANGE: Dictionary = {"min": 0, "max": 2}
const NULL_VECTOR = Vector2(-1, -1)
const AI_VALUE = 1
const PLAYER_VALUE = 0
const EMPTY_VALUE = -1

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var board: Array
var ai_pos_list: Array
var pattern: Array
var fail_test: Array
var game_node: Node

# Funzione chiamata quando il Nodo è pronto per essere usato
func _ready() -> void:
	game_node = get_parent()
	board = get_parent().game_board
	random.randomize() # Genera casualmente un nuovo seed usato dall'algortimo di generazione di numeri pseudocasuali

# Funzione usata per far decidere il tipo di mossa che l'AI
# deve compiere, in base alla difficoltà di gioco.
#
# @returns Vector2 --> Cella della griglia di gioco
func ai_move() -> Vector2:
	var x_sprite_position: Vector2

	if get_parent().difficulty == 1:
		x_sprite_position = _easy_diff()
	elif get_parent().difficulty == 2:
		x_sprite_position = _medium_diff()
	elif get_parent().difficulty == 3:
		x_sprite_position = _hard_diff()

	return x_sprite_position


# ------------------------------------------------------------- #
# Funzioni usate per generare e scegliere la posizione migliore #
# per l'AI, in base alla difficoltà di gioco.				    #
#                                                               #
# @returns Vector2 --> Posizione calcolata		    			#
func _easy_diff() -> Vector2:
	random.randomize()

	var x_coord: int = random.randi_range(RANGE.min, RANGE.max)
	var y_coord: int = random.randi_range(RANGE.min, RANGE.max)

	return Vector2(x_coord, y_coord)


func _medium_diff() -> Vector2:
	var ai_sprite_positions: Array = _find_ai_sprites()
	var player_sprite_positions: Array = _find_player_sprites()
	var ai_position: Vector2

	if ai_sprite_positions.size() == 0:
		ai_position = _easy_diff()
	else:
		ai_position = _block_move(player_sprite_positions)

		if ai_position == NULL_VECTOR:
			var win_position: Vector2 = _win_move(ai_sprite_positions)

			if win_position != NULL_VECTOR and ai_sprite_positions.size() > AI_VALUE:
				ai_position = win_position

	if ai_position == NULL_VECTOR:
		ai_position = _easy_diff()

	ai_pos_list.append(ai_position)
	return ai_position


func _hard_diff() -> Vector2:
	var ai_positions: Array = _choose_pattern()
	var ai_pos: Vector2 = NULL_VECTOR

	ai_pos = _draw_patter(ai_positions)

	if ai_pos == NULL_VECTOR or ai_pos != NULL_VECTOR:
		var block_p: Vector2 = _medium_diff()

		if block_p != NULL_VECTOR:
			ai_pos = block_p


	elif ai_pos == NULL_VECTOR:
		ai_pos = _easy_diff()

	ai_pos_list.append(ai_pos)
	return ai_pos


# ------------------------------------------------------------- #


# Funzione che ricerca le posizioni degli sprite dell'AI, sotto forma di Vector2.
#
# @returns Array --> Array contenente le posizioni.
func _find_ai_sprites() -> Array:
	var list_ai: Array = []

	for y in range(board.size()):
		for x in range(board[y].size()):
			if board[y][x] == AI_VALUE:
				list_ai.append(Vector2(x, y))

	return list_ai


# Funzione che ricerca le posizioni degli sprite del giocatore, sotto forma di Vector2.
#
# @returns Array --> Array contenente le posizioni.
func _find_player_sprites() -> Array:
	var list_player: Array = []

	for y in range(board.size()):
		for x in range(board[y].size()):
			if board[y][x] == PLAYER_VALUE:
				 list_player.append(Vector2(x, y))

	return list_player


# Funzione usata dall'AI per calcolare la mossa vincente.
#
# @params ai_sprites: Array --> Posizioni degli sprite dell'AI
#
# @retuns Vector2 --> Mossa vincente.
func _win_move(ai_sprites: Array) -> Vector2:
	var win_pos: Vector2 = NULL_VECTOR

	for i in range(ai_sprites.size()):
		win_pos = _get_horizontal_coord(ai_sprites[i].y, "win")
		if win_pos != NULL_VECTOR:
			break

		if win_pos == NULL_VECTOR:
			win_pos = _get_vertical_coord(ai_sprites[i].x, "win")
			if win_pos != NULL_VECTOR:
				break

			if win_pos == NULL_VECTOR:
				win_pos = _get_diagonal_coord("win")
				if win_pos != NULL_VECTOR:
					break

				if win_pos == NULL_VECTOR:
					win_pos == _get_anti_diagonal_coord("win")
					if win_pos != NULL_VECTOR:
						break

	if win_pos == NULL_VECTOR:
		win_pos = _easy_diff()

	return win_pos


# Funzione usata dall'AI per calcolare la mossa ideale per bloccare il giocatore dalla vittoria.
#
# @params player_sprites: Array --> Poszioni degli sprite del giocatore.
#
# @retuns Vector2 --> Posizione calcolata.
func _block_move(player_sprites: Array) -> Vector2:
	var block_pos: Vector2 = NULL_VECTOR

	for i in range(player_sprites.size()):
		if (i + 1) < player_sprites.size():

			if player_sprites[i].y == player_sprites[i + 1].y:
				block_pos = _get_horizontal_coord(player_sprites[i].y)

				if block_pos == NULL_VECTOR:
					fail_test.append(block_pos)
				break

			elif player_sprites[i].x == player_sprites[i + 1].x:
				block_pos = _get_vertical_coord(player_sprites[i].x)

				if block_pos == NULL_VECTOR:
					fail_test.append(block_pos)
				break

			elif (player_sprites[i].x == player_sprites[i].y) and (player_sprites[i + 1].x == player_sprites[i + 1].y):
				block_pos = _get_diagonal_coord()

				if block_pos == NULL_VECTOR:
					fail_test.append(block_pos)
				break

			elif (player_sprites[i].x == 2 and player_sprites[i].y == 0) or (player_sprites[i].x == 0 and player_sprites[i].y == 2) or (player_sprites[i].x == 1 and player_sprites[i].y == 1):
				if (player_sprites[i + 1].x == 2 and player_sprites[i + 1].y == 0) or (player_sprites[i + 1].x == 0 and player_sprites[i + 1].y == 2) or (player_sprites[i + 1].x == 1 and player_sprites[i + 1].y == 1):
					block_pos = _get_anti_diagonal_coord()

					if block_pos == NULL_VECTOR:
						fail_test.append(block_pos)
					break

		if block_pos != NULL_VECTOR:
			break

	return block_pos


# Funzione usata dall'AI per ricercare la posizione orizzontale migliore in caso voglia bloccare o vincere.
# Questa scelta viene fatta in base al parametro 'id', che di default ha come valore "block", infatti se
# durante la chiamata della funzione, non viene passato un valore diverso da quello di default, l'AI
# restituirà la posizione ideale per bloccare il giocatore. In caso si dovesse passare un
# valore diverso, allora l'AI cercherà la posizione ideale che la condurrà alla vittoria.
#
# @params y: int --> Coordinata y dello sprite dell'AI o del giocatore.
# @params id: String = "block" --> Identifica l'azione che l'AI deve compiere.
#
# @retuns Vector2 --> Posizione calcolata.
func _get_horizontal_coord(y: int, id: String = "block") -> Vector2:
	var pos_h: Vector2 = NULL_VECTOR

	if id == "block":
		var pos_x: int = board[y].find(EMPTY_VALUE)

		if pos_x != EMPTY_VALUE:
			pos_h = Vector2(pos_x, y)
	else:
		for x in range(board[y].size()):	# Mi assicuro di non trovare sprite del giocatori
			if board[y][x] == PLAYER_VALUE:
				return pos_h

		for x in range(board[y].size()):
			if board[y][x] != PLAYER_VALUE:
				if board[y][x] == EMPTY_VALUE:
					pos_h = Vector2(x, y)
					break
			else:
				break

	return pos_h


# Funzione usata dall'AI per ricercare la posizione verticale migliore in caso voglia bloccare o vincere.
# Questa scelta viene fatta in base al parametro 'id', che di default ha come valore "block", infatti se
# durante la chiamata della funzione, non viene passato un valore diverso da quello di default, l'AI
# restituirà la posizione ideale per bloccare il giocatore. In caso si dovesse passare un
# valore diverso, allora l'AI cercherà la posizione ideale che la condurrà alla vittoria.
#
# @params x: int --> Coordinata x dello sprite dell'AI o del giocatore.
# @params id: String = "block" --> Identifica l'azione che l'AI deve compiere.
#
# @retuns Vector2 --> Posizione calcolata.
func _get_vertical_coord(x: int, id: String = "block") -> Vector2:
	var pos_h: Vector2 = NULL_VECTOR

	if id == "block":
		for y in range(board[x].size()):
			if board[y][x] == EMPTY_VALUE:
				pos_h = Vector2(x, y)
				break
	else:
		for y in range(board[x].size()):	# Mi assicuro di non trovare sprite del giocatori
			if board[y][x] == PLAYER_VALUE:
				return pos_h

		for y in range(board[x].size()):
			if board[y][x] == EMPTY_VALUE:
				pos_h = Vector2(x, y)
				break

	return pos_h


# Funzione usata dall'AI per ricercare la posizione, fatta sulla diagonale principale, migliore in caso voglia bloccare o vincere.
# Questa scelta viene fatta in base al parametro 'id', che di default ha come valore "block", infatti se
# durante la chiamata della funzione, non viene passato un valore diverso da quello di default, l'AI
# restituirà la posizione ideale per bloccare il giocatore. In caso si dovesse passare un
# valore diverso, allora l'AI cercherà la posizione ideale che la condurrà alla vittoria.
#
# @params id: String = "block" --> Identifica l'azione che l'AI deve compiere.
#
# @retuns Vector2 --> Posizione calcolata.
func _get_diagonal_coord(id: String = "block") -> Vector2:
	var pos_h: Vector2 = NULL_VECTOR

	if id == "block":
		for i in range(board.size()):
			if board[i][i] == EMPTY_VALUE:
				pos_h = Vector2(i, i)
				break
	else:
		for i in range(board.size()):	# Mi assicuro di non trovare sprite del giocatori
			if board[i][i] == PLAYER_VALUE:
				return pos_h

		for i in range(board.size()):
			if board[i][i] == EMPTY_VALUE:
				pos_h = Vector2(i, i)
				break

	return pos_h


# Funzione usata dall'AI per ricercare la posizione, fatta sulla diagonale secondaria, migliore in caso voglia bloccare o vincere.
# Questa scelta viene fatta in base al parametro 'id', che di default ha come valore "block", infatti se
# durante la chiamata della funzione, non viene passato un valore diverso da quello di default, l'AI
# restituirà la posizione ideale per bloccare il giocatore. In caso si dovesse passare un
# valore diverso, allora l'AI cercherà la posizione ideale che la condurrà alla vittoria.
#
# @params id: String = "block" --> Identifica l'azione che l'AI deve compiere.
#
# @retuns Vector2 --> Posizione calcolata.
func _get_anti_diagonal_coord(id: String = "block") -> Vector2:
	var pos_h: Vector2 = NULL_VECTOR

	if id == "block":
		for y in range(board.size()):
			for x in range(board[y].size()):
				if ((x == 2 and y == 0) or (x == 0 and y == 2) or (x == 1 and y == 1)):
					if board[y][x] == EMPTY_VALUE:
						pos_h = Vector2(x, y)
						break

	else:
		for y in range(board.size()):	# Mi assicuro di non trovare sprite del giocatori
			for x in range(board[y].size()):
				if ((x == 2 and y == 0) or (x == 0 and y == 2) or (x == 1 and y == 1)):
					if board[y][x] == PLAYER_VALUE:
						return pos_h

		for y in range(board.size()):
			for x in range(board[y].size()):
				if ((x == 2 and y == 0) or (x == 0 and y == 2) or (x == 1 and y == 1)):
					if board[y][x] == EMPTY_VALUE:
						pos_h = Vector2(x, y)
						break


	return pos_h


# Genera casualmente il pattern iniziale dell'AI
#
# @returns Array --> Schema del pattern
func _choose_pattern() -> Array:
	var list_patterns: Array = [
		[Vector2(0, 0), Vector2(1, 1), Vector2(0, 2)],
		[Vector2(0, 0), Vector2(1, 1), Vector2(2, 0)],
		[Vector2(1, 1), Vector2(1, 2), Vector2(2, 2)],
		[Vector2(1, 0), Vector2(1, 2), Vector2(2, 2)],
		[Vector2(1, 0), Vector2(1, 1), Vector2(2, 2)]
	]
	var random_index: int

	random.randomize()
	if pattern.size() == 0:
		random_index = random.randi_range(PLAYER_VALUE, list_patterns.size() - 1)
		list_patterns.shuffle()

		list_patterns[random_index].shuffle()
		pattern = list_patterns[random_index]

		return list_patterns[random_index]

	return []


# Funzione usata per disegnare un pattern iniziale da far seguire all'AI.
#
# @params list_of_pos: Array --> Posizioni pattern
#
# @retuns Vector2 --> Posizione del pattern scelta
func _draw_patter(list_of_pos: Array) -> Vector2:
	var ai_pos: Vector2 = NULL_VECTOR

	if list_of_pos.size() != PLAYER_VALUE:
		for v in list_of_pos:
			if board[v.y][v.x] == PLAYER_VALUE: # Se trova lo sprite del giocatore, in una posizione del pattern, si blocca la sua generazione
				return ai_pos

		for v in list_of_pos:
			if board[v.y][v.x] == EMPTY_VALUE: # Trovo la posizione vuota del pattern
				ai_pos = v
				break

	elif list_of_pos.size() == PLAYER_VALUE:
		for v in pattern:
			if board[v.y][v.x] == PLAYER_VALUE: # Se trova lo sprite del giocatore, in una posizione del pattern, si blocca la sua generazione
				return ai_pos

		for v in pattern:
			if board[v.y][v.x] == EMPTY_VALUE:
				ai_pos = v
				break

	return ai_pos

