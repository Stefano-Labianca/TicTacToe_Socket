import { Vector2D } from './utility/Vector2D';

/** Contiene le informazioni sul tipo di sprite usato.  */
export const OBJ_SPRITE: {"O_S": string, "X_S": string} = {"O_S": "o_player", "X_S": "x_player"};

const PLAYERS_VALUE: {"FIRST": number, "SECOND": number} = {"FIRST": 0, "SECOND": 1};

var gameBoard: Array<Array<number>> = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
var round: number = 0


/**
 * Aggiorna lo stato della tabella di gioco del server in base alle proprietà dell'oggetto, ricevuto come parametro.
 * La proprietà 'posizione: string', contiene la posizione premuta dal giocatore. La propietà 'enemy_sprite: string'
 * contiene il tipo di sprite, assegnato al giocatore dal server.
 * 
 * @param playerInfo Oggetto contenente le informazioni sul giocatore.
 */
export function updateServeBoard(playerInfo: {posizione: string, enemy_sprite: string}): void 
{
    var playerPosition: string = playerInfo.posizione;
    var enemySprite: string = playerInfo.enemy_sprite;

    var vectorPosition: Vector2D = strToVector2D(playerPosition);

    if (enemySprite === OBJ_SPRITE.O_S)
    {
        gameBoard[vectorPosition.y][vectorPosition.x] = PLAYERS_VALUE.FIRST;
    }   

    else if (enemySprite === OBJ_SPRITE.X_S)
    {
        gameBoard[vectorPosition.y][vectorPosition.x] = PLAYERS_VALUE.SECOND;
    }
}


/**
 * Controlla quale giocatore ha vinto la partita.
 * 
 * @returns Stringa che identifica il vincitore.
 */
export function checkWinner(): string 
{
    var winnerSprite: string = "";

    winnerSprite = horizontalWinner();
    
    if (!winnerSprite) // Controllo se la variabile 'winnerSprite' è vuota  
    {
        winnerSprite = verticalWinner();

        if (!winnerSprite)
        {
            winnerSprite = diagonalWinner();

            if (!winnerSprite)
            {
                winnerSprite = antiDiagonalWinner();
            }
        }
    }

    return winnerSprite;
} 


/**
 * Convertire una stringa, del tipo '(1, 1)', in  un'istanza della classe Vector2D.
 * 
 * @param strV Stringa da convertire.
 * @returns Istanza della classe Vector2D.
 * 
 */
function strToVector2D(strV: string): Vector2D 
{
    var xCoord: number = Number.parseInt(strV[1]);
    var yCoord: number = Number.parseInt(strV[4]);

    return new Vector2D(xCoord, yCoord);
}


/**
 * Controlla se la vincita avviene sul pattern orizzonrale, restituendo
 * il tipo di sprite, usato dal vincitore.
 * 
 * @returns Vincitore della partita.
 */
function horizontalWinner(): string
{
    var winner: string = "";

    for (let y = 0; y < gameBoard.length; y++) 
    {
        if (gameBoard[y][0] === PLAYERS_VALUE.FIRST)   
        {
            if (gameBoard[y][1] === PLAYERS_VALUE.FIRST && gameBoard[y][2] === PLAYERS_VALUE.FIRST)
            {
                winner = OBJ_SPRITE.O_S;
                break;
            }
        }
        
        else if (gameBoard[y][0] === PLAYERS_VALUE.SECOND)
        {
            if (gameBoard[y][1] === PLAYERS_VALUE.SECOND && gameBoard[y][2] === PLAYERS_VALUE.SECOND)
            {
                winner = OBJ_SPRITE.X_S;
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
function verticalWinner(): string
{
    var winner: string = "";
    
    for (let x = 0; x < gameBoard.length; x++) 
    {
        if (gameBoard[0][x] === PLAYERS_VALUE.FIRST)
        {
            if (gameBoard[1][x] === PLAYERS_VALUE.FIRST && gameBoard[2][x] === PLAYERS_VALUE.FIRST)
            {
                winner = OBJ_SPRITE.O_S;
                break;
            }
        }

        else if (gameBoard[0][x] === PLAYERS_VALUE.SECOND)
        {
            if (gameBoard[1][x] === PLAYERS_VALUE.SECOND && gameBoard[2][x] === PLAYERS_VALUE.SECOND)
            {
                winner = OBJ_SPRITE.X_S;
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
function diagonalWinner(): string 
{
    var winner: string = "";

    if (gameBoard[0][0] === PLAYERS_VALUE.FIRST && gameBoard[1][1] === PLAYERS_VALUE.FIRST && gameBoard[2][2] === PLAYERS_VALUE.FIRST)
    {
        winner = OBJ_SPRITE.O_S;
    }

    else if (gameBoard[0][0] === PLAYERS_VALUE.SECOND && gameBoard[1][1] === PLAYERS_VALUE.SECOND && gameBoard[2][2] === PLAYERS_VALUE.SECOND)
    {
        winner = OBJ_SPRITE.X_S;
    }

    return winner;
}


/**
 * Controlla se la vincita avviene sulla diagonale secondaria, restituendo
 * il tipo di sprite, usato dal vincitore.
 * 
 * @returns Vincitore della partita.
 */
function antiDiagonalWinner(): string
{
    var winner: string = "";

    if (gameBoard[2][0] === PLAYERS_VALUE.FIRST && gameBoard[1][1] === PLAYERS_VALUE.FIRST && gameBoard[0][2] === PLAYERS_VALUE.FIRST)
    {
        winner = OBJ_SPRITE.O_S;
    }

    else if (gameBoard[2][0] === PLAYERS_VALUE.SECOND && gameBoard[1][1] === PLAYERS_VALUE.SECOND && gameBoard[0][2] === PLAYERS_VALUE.SECOND)
    {
        winner = OBJ_SPRITE.X_S;
    }

    return winner;
}


