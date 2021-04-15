const ws = require('ws');
const express = require('express');

const gameBoard = require('../js/board');

const port = process.env.PORT || 3000;
const app = express().listen(port, () => { console.log("Server in ascolto su " + port); });

const server = new ws.Server({ server: app });
const serverBoard = new gameBoard.Board();

const MAX_PLAYER = 2;
var rematchArray = [false, false];

/**
 * NOTA SULLA FUNZIONE on(string, callback)
 * 
 * La funzione on viene usata per gestire degli eventi. 
 * Possiede due parametri, il primo è di tipo string e ci definisce il tipo di
 * evento da gestire. Il secondo parametro è una callback che, a seconda del tipo di
 * evento da gestire, avrà diversi parametri.
*/


/** 
 * Gestione evento 'connection'. 
 * 
 * Viene attivato quando si connette un utente al server socket.
 * Il parametro che contiene la callback è di tipo WebSocket e rappresenta l'utente connesso.
 */
server.on('connection', socket => {

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

        else if (data.hasOwnProperty.call(data, "rematch")) // Supporto per il rematch della partita
        {
            if (data.rematch)
            {
                rematch(data, server.clients);
            }
        }

        else
        {
            serverBoard.updateServeBoard(data);
            console.log(data);
            
            let spriteWinner = serverBoard.checkWinner();
    
            // Invio dati all'avversario
            server.clients.forEach(client => {
                if (client != socket && client.readyState === ws.OPEN)
                {
                    client.send(JSON.stringify({"enemyInfo": data}));
                }
            });
    
            if (!!spriteWinner) // Abbiamo un vincitore
            {
                gameOver(server.clients, spriteWinner);
            }
    
            // Verifico se non ci sono pattern vincenti e ci si trova in una situazione di pareggio. 
            if (!spriteWinner && serverBoard.isDraw()) 
            {
                gameOver(server.clients, spriteWinner, true);
            }
        }
    });

        
    /** 
    * Gestione evento 'close'. 
    * 
    * Viene attivato quando si disconnette un utente dal server socket.
    * I due parametri contenuti della callback sono uno di tipo number e il secondo di tipo string. 
    * Il primo è un codice numerico usato per spiegare il motivo della disconnessione, il secondo è una stringa
    * leggibile dall'uomo che spiega il motivo della disconnessione.
    * */
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

    if (server.clients.size === MAX_PLAYER)
    {
        socket.send(JSON.stringify({"numPlayers": server.clients.size}));
        
        // La partita inizia
        startGame(server.clients);
    }

    else
    {   
        socket.send(JSON.stringify({"numPlayers": server.clients.size}));
    }
});


/**
 * Funzione usata per **determinare** quali, dei due giocatori, inizierà per **primo** o per **secondo** il gioco.
 * Un giocatore inizierà per primo se possiede lo sprite **cerchio**, il secondo invece avrà lo sprite
 * **croce**. 
 * 
 * I termini per definire chi possiede uno sprite, è quello di **chi si collega prima** alla sessione
 * di gioco.
 * 
 * @param {Array.<WebSocket>} clients - Lista di client WebSocket connessi.
 */
function startGame(clients) 
{   
    var players = [...clients];

    // Aggiungo agli oggetti JSON la proprietà 'clientName' usata per identificare il turno del giocatore
    players[0].clientName = "o_player";
    players[1].clientName = "x_player";

    // Inzio dei dati ai giocatori
    players[0].send(JSON.stringify({"spriteType": players[0].clientName, "round": "first"}));
    players[1].send(JSON.stringify({"spriteType": players[1].clientName, "round": "second"}));
}


/**
 * Funzione usata per **inviare** ai giocatori delle informazioni su **chi ha vinto e su chi ha perso**.
 * 
 * Il terzo parametro della funzione, chiamato ***draw***, viene usato per capire se i giocatori
 * si trovano in una **condizione di pareggio**. Di default il suo valore è settato a **false**, ma nel caso 
 * venisse passato il valore **true**, allora si è verificato un pareggio.
 * 
 * @param {Array.<WebSocket>} clients - Array di client WebSocket connessi.
 * @param {string} spriteWinner - Sprite vincitore.
 * @param {boolean} [draw=false] - Determina se avviene un pareggio.
 */
function gameOver(clients, spriteWinner, draw = false) 
{
    var players = [...clients];

    if (!draw) // Non si è verificato il pareggio
    {
        if (spriteWinner === serverBoard.OBJ_SPRITE.O_S) // Vince il giocatore 1
        {
            players[0].send(JSON.stringify({"gameover": "win"}));
            players[1].send(JSON.stringify({"gameover": "lose"}));
        }
    
        else if (spriteWinner === serverBoard.OBJ_SPRITE.X_S) // Vince il giocatore 2
        {
            players[0].send(JSON.stringify({"gameover": "lose"}));
            players[1].send(JSON.stringify({"gameover": "win"}));
        }    
    }

    else if (draw) // Si è verificato il pareggio
    {
        players[0].send(JSON.stringify({"gameover": "draw"}));
        players[1].send(JSON.stringify({"gameover": "draw"}));
    }
}


/**
 * Viene usata per controllare se **entrambi i giocatori** vogliono rigiocare la partita.
 * @param {Object[]} info - Oggetto contenente le informazioni.
 * @param {boolean} info.rematch - Se è **true** vuole il remacth, **false** no.
 * @param {boolean} info.player - Sprite del giocatore che vuole o meno la rivincita.
 * @param {Array.<WebSocket>} clients - Array di client WebSocket connessi.
 */
function rematch(info, clients) 
{
    let copyRematch = [...rematchArray];
    let players = [...clients];

    if (info.rematch && info.player == serverBoard.OBJ_SPRITE.O_S)
    {
        copyRematch[0] = true;

        if (copyRematch.every(elements => elements == true))
        {
            serverBoard.restart();

            players[0].send(JSON.stringify({"server_rematch": true}));
            players[1].send(JSON.stringify({"server_rematch": true}));
        
            rematchArray = [false, false];
            
            players[0].send(JSON.stringify({"spriteType": players[0].clientName, "round": "first"}));
            players[1].send(JSON.stringify({"spriteType": players[1].clientName, "round": "second"}));
        }

        else
        {
            rematchArray = [...copyRematch];
            players[1].send(JSON.stringify({"rematch_request": true}));
        }
    }

    else if (info.rematch && info.player == serverBoard.OBJ_SPRITE.X_S)
    {
        copyRematch[1] = true;

        if (copyRematch.every(elements => elements == true))
        {
            serverBoard.restart();

            players[0].send(JSON.stringify({"server_rematch": true}));
            players[1].send(JSON.stringify({"server_rematch": true}));

            rematchArray = [false, false];
            
            players[0].send(JSON.stringify({"spriteType": players[0].clientName, "round": "first"}));
            players[1].send(JSON.stringify({"spriteType": players[1].clientName, "round": "second"}));
        }

        else
        {
            rematchArray = [...copyRematch];
            players[0].send(JSON.stringify({"rematch_request": true}));
        }
    }
}