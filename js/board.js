"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Board = void 0;
const Vector2D_1 = require("./utility/Vector2D");
/**
 * ## Classe Board
 *
 * La classe Board viene usata per **creare e gestire** sul server, la tabella di gioco dei due giocatori.
 *
 */
class Board {
    /** @constructor Costruttore classe Board. */
    constructor() {
        this.OBJ_SPRITE = { "O_S": "o_player", "X_S": "x_player" };
        this.PLAYERS_VALUE = { "FIRST": 0, "SECOND": 1 };
        this.EMPTY_CELL = -1;
        this.gameBoard = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
        this.round = 0;
    }
    /**
     * **Aggiorna** lo stato della tabella di gioco del server in base alle proprietà dell'oggetto, ricevuto come parametro.
     * La proprietà ***posizione: string***, contiene la posizione premuta dal giocatore. La propietà ***enemy_sprite: string***
     * contiene il tipo di sprite, assegnato al giocatore dal server.
     *
     * @param playerInfo Oggetto contenente le informazioni sul giocatore.
     */
    updateServeBoard(playerInfo) {
        var playerPosition = playerInfo.posizione;
        var enemySprite = playerInfo.enemy_sprite;
        var vectorPosition = this.strToVector2D(playerPosition);
        if (enemySprite === this.OBJ_SPRITE.O_S) {
            this.gameBoard[vectorPosition.y][vectorPosition.x] = this.PLAYERS_VALUE.FIRST;
        }
        else if (enemySprite === this.OBJ_SPRITE.X_S) {
            this.gameBoard[vectorPosition.y][vectorPosition.x] = this.PLAYERS_VALUE.SECOND;
        }
    }
    /**
     * Controlla quale giocatore ha **vinto** la partita.
     *
     * @returns Stringa che identifica il vincitore.
     */
    checkWinner() {
        var winnerSprite = "";
        winnerSprite = this.horizontalWinner();
        if (!winnerSprite) // Controllo se la variabile 'winnerSprite' è vuota  
         {
            winnerSprite = this.verticalWinner();
            if (!winnerSprite) {
                winnerSprite = this.diagonalWinner();
                if (!winnerSprite) {
                    winnerSprite = this.antiDiagonalWinner();
                }
            }
        }
        return winnerSprite;
    }
    /**
     * Fa **ripartire** la partita di gioco.
     */
    restart() {
        this.gameBoard = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
    }
    /**
     * Controlla se avviene un caso di **pareggio**. Si verificherà in caso
     * all'interno della griglia di gioco, **nessuno** dei due gocatori a dato vita
     * ad un **pattern** che permettessero la sua vincita e, sopratutto, se **non ci sono** più
     * celle libere.
     *
     * In caso ci fossero delle celle libere, restituirà **false**, altrimenti **true**.
     *
     * @returns Esito ricerca.
     */
    isDraw() {
        for (let i = 0; i < this.gameBoard.length; i++) {
            let result = this.gameBoard[i].find((element) => element === this.EMPTY_CELL);
            if (result !== undefined) {
                return false;
            }
        }
        return true;
    }
    /**
     * Convertire una stringa, del tipo ***(1, 1)***, in  un'istanza della classe **Vector2D**.
     *
     * @param strV Stringa da convertire.
     * @returns Istanza della classe Vector2D.
     *
     */
    strToVector2D(strV) {
        var xCoord = Number.parseInt(strV[1]);
        var yCoord = Number.parseInt(strV[4]);
        return new Vector2D_1.Vector2D(xCoord, yCoord);
    }
    /**
     * Controlla se la vincita avviene sul **pattern orizzonrale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    horizontalWinner() {
        var winner = "";
        for (let y = 0; y < this.gameBoard.length; y++) {
            if (this.gameBoard[y][0] === this.PLAYERS_VALUE.FIRST) {
                if (this.gameBoard[y][1] === this.PLAYERS_VALUE.FIRST && this.gameBoard[y][2] === this.PLAYERS_VALUE.FIRST) {
                    winner = this.OBJ_SPRITE.O_S;
                    break;
                }
            }
            else if (this.gameBoard[y][0] === this.PLAYERS_VALUE.SECOND) {
                if (this.gameBoard[y][1] === this.PLAYERS_VALUE.SECOND && this.gameBoard[y][2] === this.PLAYERS_VALUE.SECOND) {
                    winner = this.OBJ_SPRITE.X_S;
                    break;
                }
            }
        }
        return winner;
    }
    /**
     * Controlla se la vincita avviene sul **pattern verticale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    verticalWinner() {
        var winner = "";
        for (let x = 0; x < this.gameBoard.length; x++) {
            if (this.gameBoard[0][x] === this.PLAYERS_VALUE.FIRST) {
                if (this.gameBoard[1][x] === this.PLAYERS_VALUE.FIRST && this.gameBoard[2][x] === this.PLAYERS_VALUE.FIRST) {
                    winner = this.OBJ_SPRITE.O_S;
                    break;
                }
            }
            else if (this.gameBoard[0][x] === this.PLAYERS_VALUE.SECOND) {
                if (this.gameBoard[1][x] === this.PLAYERS_VALUE.SECOND && this.gameBoard[2][x] === this.PLAYERS_VALUE.SECOND) {
                    winner = this.OBJ_SPRITE.X_S;
                    break;
                }
            }
        }
        return winner;
    }
    /**
     * Controlla se la vincita avviene sulla **diagonale principale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    diagonalWinner() {
        var winner = "";
        if (this.gameBoard[0][0] === this.PLAYERS_VALUE.FIRST && this.gameBoard[1][1] === this.PLAYERS_VALUE.FIRST && this.gameBoard[2][2] === this.PLAYERS_VALUE.FIRST) {
            winner = this.OBJ_SPRITE.O_S;
        }
        else if (this.gameBoard[0][0] === this.PLAYERS_VALUE.SECOND && this.gameBoard[1][1] === this.PLAYERS_VALUE.SECOND && this.gameBoard[2][2] === this.PLAYERS_VALUE.SECOND) {
            winner = this.OBJ_SPRITE.X_S;
        }
        return winner;
    }
    /**
     * Controlla se la vincita avviene sulla **diagonale secondaria**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    antiDiagonalWinner() {
        var winner = "";
        if (this.gameBoard[2][0] === this.PLAYERS_VALUE.FIRST && this.gameBoard[1][1] === this.PLAYERS_VALUE.FIRST && this.gameBoard[0][2] === this.PLAYERS_VALUE.FIRST) {
            winner = this.OBJ_SPRITE.O_S;
        }
        else if (this.gameBoard[2][0] === this.PLAYERS_VALUE.SECOND && this.gameBoard[1][1] === this.PLAYERS_VALUE.SECOND && this.gameBoard[0][2] === this.PLAYERS_VALUE.SECOND) {
            winner = this.OBJ_SPRITE.X_S;
        }
        return winner;
    }
}
exports.Board = Board;
