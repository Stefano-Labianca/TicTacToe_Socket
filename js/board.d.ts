/** Contiene le informazioni sul tipo di sprite usato.  */
export declare const OBJ_SPRITE: {
    "O_S": string;
    "X_S": string;
};
/**
 * Aggiorna lo stato della tabella di gioco del server in base alle proprietà dell'oggetto, ricevuto come parametro.
 * La proprietà 'posizione: string', contiene la posizione premuta dal giocatore. La propietà 'enemy_sprite: string'
 * contiene il tipo di sprite, assegnato al giocatore dal server.
 *
 * @param playerInfo Oggetto contenente le informazioni sul giocatore.
 */
export declare function updateServeBoard(playerInfo: {
    posizione: string;
    enemy_sprite: string;
}): void;
/**
 * Controlla quale giocatore ha vinto la partita.
 *
 * @returns Stringa che identifica il vincitore.
 */
export declare function checkWinner(): string;
/**
 * Fa ripartire la partita di gioco.
*/
export declare function restart(): void;
