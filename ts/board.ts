import { Vector2D } from './utility/Vector2D';

/**
 * ## Classe Board
 * 
 * La classe Board viene usata per **creare e gestire** sul server, la tabella di gioco dei due giocatori.
 * 
 */
export class Board 
{
    /** Contiene le informazioni sugli sprite dei giocatori 
     * 
     * O_S -> Sprite giocatore che possiede i cerchi.
     * 
     * X_S -> Sprite giocatore che possiede le croci.
    */
    public OBJ_SPRITE: {"O_S": string, "X_S": string};

    /** Contiene le informazioni sul tipo di flag assegnare al giocatore.
     *      
     * FIRST = 0 -> Giocatore 1; 
     * 
     * SECOND = 1 -> Giocatore 2;
    */
    public PLAYERS_VALUE: {"FIRST": number, "SECOND": number};

    /** Definisce il valore della cella vuota, ovvero -1. */
    public EMPTY_CELL: number;
    
    /** Rappresenta la griglia di gioco. */
    public gameBoard: Array<Array<number>>;

    /** Definisce il numero di round. */
    public round: number;

    /** @constructor Costruttore classe Board. */
    constructor() 
    {
        this.OBJ_SPRITE = {"O_S": "o_player", "X_S": "x_player"};
        this.PLAYERS_VALUE = {"FIRST": 0, "SECOND": 1};
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
    public updateServeBoard(playerInfo: {posizione: string, enemy_sprite: string}): void 
    {
        var playerPosition: string = playerInfo.posizione;
        var enemySprite: string = playerInfo.enemy_sprite;
    
        var vectorPosition: Vector2D = this.strToVector2D(playerPosition);
    
        if (enemySprite === this.OBJ_SPRITE.O_S)
        {
            this.gameBoard[vectorPosition.y][vectorPosition.x] = this.PLAYERS_VALUE.SECOND;
        }   
    
        else if (enemySprite === this.OBJ_SPRITE.X_S)
        {
            this.gameBoard[vectorPosition.y][vectorPosition.x] = this.PLAYERS_VALUE.FIRST;
        }
    }
    
    
    /**
     * Controlla quale giocatore ha **vinto** la partita.
     * 
     * @returns Stringa che identifica il vincitore.
     */
    public checkWinner(): string 
    {
        var winnerSprite: string = "";
    
        winnerSprite = this.horizontalWinner();
        
        if (!winnerSprite) // Controllo se la variabile 'winnerSprite' è vuota  
        {
            winnerSprite = this.verticalWinner();
        
            if (!winnerSprite)
            {
                winnerSprite = this.diagonalWinner();
            
                if (!winnerSprite)
                {
                    winnerSprite = this.antiDiagonalWinner();
                }
            }
        }
    
        return winnerSprite;
    } 
    
    
    /**
     * Fa **ripartire** la partita di gioco.
     */
    public restart(): void 
    {
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
    public isDraw(): boolean 
    {
        for (let i = 0; i < this.gameBoard.length; i++) 
        {
            let result = this.gameBoard[i].find((element: number) => element === this.EMPTY_CELL);
            
            if (result !== undefined)
            {
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
    private strToVector2D(strV: string): Vector2D 
    {
        var xCoord: number = Number.parseInt(strV[1]);
        var yCoord: number = Number.parseInt(strV[4]);
    
        return new Vector2D(xCoord, yCoord);
    }
    
    
    /**
     * Controlla se la vincita avviene sul **pattern orizzonrale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     * 
     * @returns Vincitore della partita.
     */
    private horizontalWinner(): string
    {
        var winner: string = "";
    
        for (let y = 0; y < this.gameBoard.length; y++) 
        {
            if (this.gameBoard[y][0] === this.PLAYERS_VALUE.SECOND)   
            {
                if (this.gameBoard[y][1] === this.PLAYERS_VALUE.SECOND && this.gameBoard[y][2] === this.PLAYERS_VALUE.SECOND)
                {
                    winner = this.OBJ_SPRITE.O_S;
                    break;
                }
            }
            
            else if (this.gameBoard[y][0] === this.PLAYERS_VALUE.FIRST)
            {
                if (this.gameBoard[y][1] === this.PLAYERS_VALUE.FIRST && this.gameBoard[y][2] === this.PLAYERS_VALUE.FIRST)
                {
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
    private verticalWinner(): string
    {
        var winner: string = "";
        
        for (let x = 0; x < this.gameBoard.length; x++) 
        {
            if (this.gameBoard[0][x] === this.PLAYERS_VALUE.SECOND)
            {
                if (this.gameBoard[1][x] === this.PLAYERS_VALUE.SECOND && this.gameBoard[2][x] === this.PLAYERS_VALUE.SECOND)
                {
                    winner = this.OBJ_SPRITE.O_S;
                    break;
                }
            }
        
            else if (this.gameBoard[0][x] === this.PLAYERS_VALUE.FIRST)
            {
                if (this.gameBoard[1][x] === this.PLAYERS_VALUE.FIRST && this.gameBoard[2][x] === this.PLAYERS_VALUE.FIRST)
                {
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
    private diagonalWinner(): string 
    {
        var winner: string = "";
    
        if (this.gameBoard[0][0] === this.PLAYERS_VALUE.SECOND && this.gameBoard[1][1] === this.PLAYERS_VALUE.SECOND && this.gameBoard[2][2] === this.PLAYERS_VALUE.SECOND)
        {
            winner = this.OBJ_SPRITE.O_S;
        }
    
        else if (this.gameBoard[0][0] === this.PLAYERS_VALUE.FIRST && this.gameBoard[1][1] === this.PLAYERS_VALUE.FIRST && this.gameBoard[2][2] === this.PLAYERS_VALUE.FIRST)
        {
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
    private antiDiagonalWinner(): string
    {
        var winner: string = "";
    
        if (this.gameBoard[2][0] === this.PLAYERS_VALUE.SECOND && this.gameBoard[1][1] === this.PLAYERS_VALUE.SECOND && this.gameBoard[0][2] === this.PLAYERS_VALUE.SECOND)
        {
            winner = this.OBJ_SPRITE.O_S;
        }
    
        else if (this.gameBoard[2][0] === this.PLAYERS_VALUE.FIRST && this.gameBoard[1][1] === this.PLAYERS_VALUE.FIRST && this.gameBoard[0][2] === this.PLAYERS_VALUE.FIRST)
        {
            winner = this.OBJ_SPRITE.X_S;
        }
    
        return winner;
    }
}