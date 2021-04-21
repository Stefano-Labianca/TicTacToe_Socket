# Server Con NodeJS

## Indice

- [Server Con NodeJS](#server-con-nodejs)
  - [Indice](#indice)
  - [Introduzione](#introduzione)
  - [Spiegazioni](#spiegazioni)
    - [Express](#express)
    - [ws](#ws)
    - [TypeScript](#typescript)

## Introduzione

Il server che gestisce le richieste e l'invio delle risposte ad ogni client, è stato gestito con **NodeJS**, un runtime che permette di creare un web server con JavaScript. Esso è stato creato tramite diverse moduli JavaScript, ovvero:

- **Express**: Crea il web server;
- **ws**: Permette la comunicazione in tempo reale grazie ai WebSocket;
- **TypeScript**: Ci permette di creare file JavaScript tipizzati, per poi compilarli in JavaScript vanilla;

> **NOTA DI SVILUPPO**: Per visualizzare in modo più chiaro e leggibile i file `Vector2D.js` e `board.js`, contenuni nella cartella *js*, andate nella cartella *ts*, che contiene la versione TypeScript del codice.

## Spiegazioni

### Express

Questo parte di codice ci permette di creare un'applicazione che girerà su server e la funzione `listen()`, abiliterà l'applicazione nell'ascoltare e ricevere nuove connessioni, sulla porta 3000, in caso si dovesse lavorare in **locale**, oppure su una porta **scelta** dal server a cui si appoccia l'applicazione. In questo caso, si tratta di Heroku.

```javascript
const port = process.env.PORT || 3000;
const app = express().listen(port, () => { console.log("Server in ascolto su " + port); });
```

### ws

Creazione dell'istanza della classe WebSocketServer.

```javascript
const server = new ws.Server({ server: app });
```

Quest'istanza andrà a lavorare sugli eventi che si possono generare, nel nostro caso, abbiamo gestito gli eventi:

- `connection`: Si attiva quando al WebSocketServer si **connette** un giocatore;
- `message`: Si attiva quando il WebSocketServer **riceve** un messaggio da un giocatore;
- `close`: Si attiva quando un giocatore si **disconnette** dal WebSocketServer;

Connessione al WebSocketServer

```javascript
/** 
 * Gestione evento 'connection'. 
 * 
 * Viene attivato quando si connette un utente al server socket.
 * Il parametro che contiene la callback è di tipo WebSocket e rappresenta l'utente connesso.
 */
server.on('connection', socket => {
    // Gestione connessioni
});
```

Invio dei messaggi ai giocatori connessi, spediti al server tramite la chat di gioco.

```javascript
 /** 
    * Gestione evento 'message'. 
    * 
    * Viene attivato quando un untente manda un messaggio al server.
    * Il parametro che contiene la callback è di tipo string e rappresenta il messaggio inviato da un utente.
    */
    socket.on('message', message => {
        let data = JSON.parse(message);

        if (data.hasOwnProperty.call(data, "chat"))
        {
            console.log(data);

            // Invio messaggio della chat
            server.clients.forEach(client => {
                if (client != socket && client.readyState === ws.OPEN)
                {
                    client.send(JSON.stringify(data));
                }
            });
        }
    });
```

Verifica se un giocatore si disconnette.

```javascript
socket.on('close', (code, reason) => {
    if (server.clients.size > 0) // Controllo se ci sono ancora dei giocatori
    {
        if (code != 1006)
        {
            if (reason.substring(0, reason.length - 1) === "giveup")
            {
                let lastOne = [...server.clients];
                lastOne[0].send(JSON.stringify({"gameover": "enemy_quit"}));
            }

            else if (!reason.rematch)
            {
                let lastOne = [...server.clients];
                lastOne[0].send(JSON.stringify({"no_rematch": true}));
            }
        }

        else
        {
            let lastOne = [...server.clients];
            lastOne[0].send(JSON.stringify({"gameover": "enemy_quit"}));
        }
    }
    
    else
    {
        console.log("Partita senza giocatori :(");
        serverBoard.restart();
        rematchArray = [false, false];
    }
});
```

### TypeScript

TypeScript, viene utilizzato per gestire in maniera più semplice e leggibile la tabella di gioco.

Aggiornamento della tabella di gioco.

```javascript
this.OBJ_SPRITE = {"O_S": "o_player", "X_S": "x_player"};
this.PLAYERS_VALUE = {"FIRST": 0, "SECOND": 1};

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
```

Controllo quale giocatore ha vinto.

```javascript
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
```
