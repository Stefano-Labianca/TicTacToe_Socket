"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.restart = exports.checkWinner = exports.updateServeBoard = exports.OBJ_SPRITE = void 0;
const Vector2D_1 = require("./utility/Vector2D");
/** Contiene le informazioni sul tipo di sprite usato.  */
exports.OBJ_SPRITE = { "O_S": "o_player", "X_S": "x_player" };
const PLAYERS_VALUE = { "FIRST": 0, "SECOND": 1 };
var gameBoard = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
var round = 0;
/**
 * Aggiorna lo stato della tabella di gioco del server in base alle proprietà dell'oggetto, ricevuto come parametro.
 * La proprietà 'posizione: string', contiene la posizione premuta dal giocatore. La propietà 'enemy_sprite: string'
 * contiene il tipo di sprite, assegnato al giocatore dal server.
 *
 * @param playerInfo Oggetto contenente le informazioni sul giocatore.
 */
function updateServeBoard(playerInfo) {
    var playerPosition = playerInfo.posizione;
    var enemySprite = playerInfo.enemy_sprite;
    var vectorPosition = strToVector2D(playerPosition);
    if (enemySprite === exports.OBJ_SPRITE.O_S) {
        gameBoard[vectorPosition.y][vectorPosition.x] = PLAYERS_VALUE.FIRST;
    }
    else if (enemySprite === exports.OBJ_SPRITE.X_S) {
        gameBoard[vectorPosition.y][vectorPosition.x] = PLAYERS_VALUE.SECOND;
    }
}
exports.updateServeBoard = updateServeBoard;
/**
 * Controlla quale giocatore ha vinto la partita.
 *
 * @returns Stringa che identifica il vincitore.
 */
function checkWinner() {
    var winnerSprite = "";
    winnerSprite = horizontalWinner();
    if (!winnerSprite) // Controllo se la variabile 'winnerSprite' è vuota  
     {
        winnerSprite = verticalWinner();
        if (!winnerSprite) {
            winnerSprite = diagonalWinner();
            if (!winnerSprite) {
                winnerSprite = antiDiagonalWinner();
            }
        }
    }
    return winnerSprite;
}
exports.checkWinner = checkWinner;
/**
 * Fa ripartire la partita di gioco.
*/
function restart() {
    gameBoard = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
}
exports.restart = restart;
/**
 * Convertire una stringa, del tipo '(1, 1)', in  un'istanza della classe Vector2D.
 *
 * @param strV Stringa da convertire.
 * @returns Istanza della classe Vector2D.
 *
 */
function strToVector2D(strV) {
    var xCoord = Number.parseInt(strV[1]);
    var yCoord = Number.parseInt(strV[4]);
    return new Vector2D_1.Vector2D(xCoord, yCoord);
}
/**
 * Controlla se la vincita avviene sul pattern orizzonrale, restituendo
 * il tipo di sprite, usato dal vincitore.
 *
 * @returns Vincitore della partita.
 */
function horizontalWinner() {
    var winner = "";
    for (let y = 0; y < gameBoard.length; y++) {
        if (gameBoard[y][0] === PLAYERS_VALUE.FIRST) {
            if (gameBoard[y][1] === PLAYERS_VALUE.FIRST && gameBoard[y][2] === PLAYERS_VALUE.FIRST) {
                winner = exports.OBJ_SPRITE.O_S;
                break;
            }
        }
        else if (gameBoard[y][0] === PLAYERS_VALUE.SECOND) {
            if (gameBoard[y][1] === PLAYERS_VALUE.SECOND && gameBoard[y][2] === PLAYERS_VALUE.SECOND) {
                winner = exports.OBJ_SPRITE.X_S;
                break;
            }
        }
    }
    return winner;
}
/**
 * Controlla se la vincita avviene sul pattern verticale, restituendo
 * il tipo di sprite, usato dal vincitore.
 *
 * @returns Vincitore della partita.
 */
function verticalWinner() {
    var winner = "";
    for (let x = 0; x < gameBoard.length; x++) {
        if (gameBoard[0][x] === PLAYERS_VALUE.FIRST) {
            if (gameBoard[1][x] === PLAYERS_VALUE.FIRST && gameBoard[2][x] === PLAYERS_VALUE.FIRST) {
                winner = exports.OBJ_SPRITE.O_S;
                break;
            }
        }
        else if (gameBoard[0][x] === PLAYERS_VALUE.SECOND) {
            if (gameBoard[1][x] === PLAYERS_VALUE.SECOND && gameBoard[2][x] === PLAYERS_VALUE.SECOND) {
                winner = exports.OBJ_SPRITE.X_S;
                break;
            }
        }
    }
    return winner;
}
/**
 * Controlla se la vincita avviene sulla diagonale principale, restituendo
 * il tipo di sprite, usato dal vincitore.
 *
 * @returns Vincitore della partita.
 */
function diagonalWinner() {
    var winner = "";
    if (gameBoard[0][0] === PLAYERS_VALUE.FIRST && gameBoard[1][1] === PLAYERS_VALUE.FIRST && gameBoard[2][2] === PLAYERS_VALUE.FIRST) {
        winner = exports.OBJ_SPRITE.O_S;
    }
    else if (gameBoard[0][0] === PLAYERS_VALUE.SECOND && gameBoard[1][1] === PLAYERS_VALUE.SECOND && gameBoard[2][2] === PLAYERS_VALUE.SECOND) {
        winner = exports.OBJ_SPRITE.X_S;
    }
    return winner;
}
/**
 * Controlla se la vincita avviene sulla diagonale secondaria, restituendo
 * il tipo di sprite, usato dal vincitore.
 *
 * @returns Vincitore della partita.
 */
function antiDiagonalWinner() {
    var winner = "";
    if (gameBoard[2][0] === PLAYERS_VALUE.FIRST && gameBoard[1][1] === PLAYERS_VALUE.FIRST && gameBoard[0][2] === PLAYERS_VALUE.FIRST) {
        winner = exports.OBJ_SPRITE.O_S;
    }
    else if (gameBoard[2][0] === PLAYERS_VALUE.SECOND && gameBoard[1][1] === PLAYERS_VALUE.SECOND && gameBoard[0][2] === PLAYERS_VALUE.SECOND) {
        winner = exports.OBJ_SPRITE.X_S;
    }
    return winner;
}
