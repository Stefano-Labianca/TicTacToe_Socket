/**
 * ## Classe Board
 *
 * La classe Board viene usata per **creare e gestire** sul server, la tabella di gioco dei due giocatori.
 *
 */
export declare class Board {
    /** Contiene le informazioni sugli sprite dei giocatori
     *
     * O_S -> Sprite giocatore che possiede i cerchi.
     *
     * X_S -> Sprite giocatore che possiede le croci.
    */
    OBJ_SPRITE: {
        "O_S": string;
        "X_S": string;
    };
    /** Contiene le informazioni sul tipo di flag assegnare al giocatore.
     *
     * FIRST = 0 -> Giocatore 1;
     *
     * SECOND = 1 -> Giocatore 2;
    */
    PLAYERS_VALUE: {
        "FIRST": number;
        "SECOND": number;
    };
    /** Definisce il valore della cella vuota, ovvero -1. */
    EMPTY_CELL: number;
    /** Rappresenta la griglia di gioco. */
    gameBoard: Array<Array<number>>;
    /** Definisce il numero di round. */
    round: number;
    /** @constructor Costruttore classe Board. */
    constructor();
    /**
     * **Aggiorna** lo stato della tabella di gioco del server in base alle proprietà dell'oggetto, ricevuto come parametro.
     * La proprietà ***posizione: string***, contiene la posizione premuta dal giocatore. La propietà ***enemy_sprite: string***
     * contiene il tipo di sprite, assegnato al giocatore dal server.
     *
     * @param playerInfo Oggetto contenente le informazioni sul giocatore.
     */
    updateServeBoard(playerInfo: {
        posizione: string;
        enemy_sprite: string;
    }): void;
    /**
     * Controlla quale giocatore ha **vinto** la partita.
     *
     * @returns Stringa che identifica il vincitore.
     */
    checkWinner(): string;
    /**
     * Fa **ripartire** la partita di gioco.
     */
    restart(): void;
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
    isDraw(): boolean;
    /**
     * Convertire una stringa, del tipo ***(1, 1)***, in  un'istanza della classe **Vector2D**.
     *
     * @param strV Stringa da convertire.
     * @returns Istanza della classe Vector2D.
     *
     */
    private strToVector2D;
    /**
     * Controlla se la vincita avviene sul **pattern orizzonrale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    private horizontalWinner;
    /**
     * Controlla se la vincita avviene sul **pattern verticale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    private verticalWinner;
    /**
     * Controlla se la vincita avviene sulla **diagonale principale**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    private diagonalWinner;
    /**
     * Controlla se la vincita avviene sulla **diagonale secondaria**, restituendo
     * il tipo di sprite, usato dal vincitore.
     *
     * @returns Vincitore della partita.
     */
    private antiDiagonalWinner;
}
