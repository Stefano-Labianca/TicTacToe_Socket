const ws = require('ws');
const express = require('express');

const port = process.env.PORT || 3000;
const app = express().listen(port, () => { console.log("Server in ascolto su " + port); });

const server = new ws.Server({ server: app });
const MAX_PLAYER = 2;


/**
 * NOTA SULLA FUNZIONE on(string, callback)
 * 
 * La funzione on viene usata per gestire degli eventi. 
 * Possiede due parametri, il primo è di tipo string e ci definisce il tipo di
 * evento da gestire. Il secondo parametro è una callback che, a seconda del tipo di
 * evento da gestire, avrà diversi parametri.
 */


/** 
 * Gestione evento 'connection'. Viene attivato quando si connette un utente al server socket.
 * Il parametro che contiene la callback è di tipo WebSocket e rappresenta l'utente connesso.
 */
server.on('connection', socket => {

    /** 
    * Gestione evento 'message'. Viene attivato quando un untente manda un messaggio al server.
    * Il parametro che contiene la callback è di tipo string e rappresenta il messaggio inviato da un utente.
    */
    socket.on('message', message => {
        let data = JSON.parse(message);
        console.log(data);

        // Invio dati all'avversario
        server.clients.forEach(client => {
            if (client != socket && client.readyState === ws.OPEN)
            {
                client.send(JSON.stringify({"enemyInfo": data}));
            }
        });
    });

    
    /** 
    * Gestione evento 'close'. Viene attivato quando si disconnette un utente dal server socket.
    * I parametri due parametri contenuti della callback sono uno di tipo number e il secondo di tipo string. 
    * Il primo è un codice numerico usato per spiegare il motivo della disconnessione, il secondo è una stringa
    * leggibile dall'uomo che spiega il perchè si è disconnesso.
    * */
    socket.on('close', (code, reason) => {
        console.log("Code: " + code, " Reason: " + reason);
    });

    if (server.clients.size === MAX_PLAYER)
    {
        socket.send(JSON.stringify({"numPlayers": server.clients.size}));
        
        // Funzione chiamata per far partire la partita
        startGame(server.clients);
    }

    else
    {   
        socket.send(JSON.stringify({"numPlayers": server.clients.size}));
    }
});


/**
 * Funzione usata per determinare quali, dei due giocatori, inizierà per primo o per secondo il gioco.
 * Un giocatore inizierà per primo se possiede lo sprite 'cerchio', il secondo invece avrà lo sprite
 * 'croce'. 
 * 
 * I termini per definire chi possiede uno sprite, è quello di chi si collega prima alla sessione
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
    players[0].send(JSON.stringify({"spriteType": players[0].clientName}));
    players[1].send(JSON.stringify({"spriteType": players[1].clientName}));
}