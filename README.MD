# Tic Tac Toe + Socket

Il semplice gioco del Tris, unito al concetto dei **socket**.
Su questo [link](http://stefanolab.altervista.org/TicTacToe/index.html) potete accedere al sito per scaricare il gioco.

## Indice

- [Tic Tac Toe + Socket](#tic-tac-toe--socket)
  - [Indice](#indice)
  - [Chi siamo](#chi-siamo)
  - [Documentazione](#documentazione)
    - [Introduzione](#introduzione)
    - [Esempio codice in GDScript](#esempio-codice-in-gdscript)
    - [Esempio codice in TypeScript](#esempio-codice-in-typescript)
    - [Esempio codice in NodeJS](#esempio-codice-in-nodejs)
    - [File di documentazione](#file-di-documentazione)
  - [Tecnologie utilizzate](#tecnologie-utilizzate)
    - [Front-end](#front-end)
      - [**Godot Game Engine**](#godot-game-engine)
      - [**Pixilart**](#pixilart)
    - [Back-end](#back-end)
      - [**ExpressJS**](#expressjs)
      - [**WS**](#ws)
      - [**TypeScript**](#typescript)
  - [LICENZA](#licenza)

## Chi siamo

- **Labianca Stefano**:
  - Creazione del gioco
  - Back-end con NodeJS e TypeScript
- **Paparusso Marialuisa**:
  - Back-end con TypeScript
  - Comparto audio-visivo
  - Creazione sito web

## Documentazione

### Introduzione

Per visualizzare la documentazione dell'intero progetto, ci sono due file appositi. Uno di questi vi permettono di visualizzare le spiegazioni dei metodi e delle funzionalità del **motore grafico**, l'altro invece spiega metodi e funzionamento del **server**. All'interno della stessa cartella potete trovare anche il diagramma di flusso del funzionamento del programma.

[Cartella](docs) della documentazione.

### Esempio codice in GDScript

```python
# Funzione che controlla se ci sono abbastanza giocatori per poter iniziare la partita.
#
# @params payload: Dictionary --> Contiene il numero dei giocatori
func _verify_room(payload: Dictionary) -> void:
    main_menu_node = get_tree().get_root().get_node("Game/MainMenu")

  if payload.get("numPlayers") < MAX_PLAYER:
    main_menu_node.visible = false
    wait_node.visible = true

  if  payload.get("numPlayers") > MAX_PLAYER:
    _client.disconnect_from_host(1000, "sono di troppo :(") # Disconnetto il client

  disconnect_multiplayer_signals()
```

### Esempio codice in TypeScript

```javascript
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
```

### Esempio codice in NodeJS

```javascript
const ws = require('ws');
const express = require('express');

const gameBoard = require('../js/board');

const port = process.env.PORT || 3000;
const app = express().listen(port, () => { console.log("Server in ascolto su " + port); });

const server = new ws.Server({ server: app });
const serverBoard = new gameBoard.Board();
```

### File di documentazione

- [**Gioco**](docs/GIOCO.md)
- [**Server**](docs/SERVER.md)
- [**Diagramma**](docs/UML.png)

## Tecnologie utilizzate

Nella realizzazione di questo progetto, abbiamo utilizzato la **tecnologia web** (HTML, CSS, JS) per la realizzazione
del sito web dove poter scaricare il gioco.

Per realizzare il **gioco**, invece, abbiamo utilizzato il motore grafico open-source **Godot**, sfruttando il linguaggio GDScript. Per il back-end abbiamo sfruttato **NodeJS**, un runtime di JavaScript che permette l'esecuzione del linguaggio JavaScript su un server. Insieme a NodeJS, abbiamo utilizzato tre moduli qui elencati:

- **ExpressJS**
- **ws**
- **TypeScript**

### Front-end

#### **Godot Game Engine**

Godot è un motore grafico open-source che utilizza il linguaggio GDScript, insieme al C++ e al C#, per creare dei veri e propri videogiochi.

Sito ufficiale del motore grafico: [Godot Game Engine](https://godotengine.org/).

#### **Pixilart**

Sito che ti permette di creare e animare pixel art.

Sito ufficiale: [Pixilart](https://www.pixilart.com/).

### Back-end

#### **ExpressJS**

Express è un web framework per NodeJS, utilizzato per **creare un server** che gestirà le richieste e le risposte dei client connessi.

Sito web ufficiale del modulo: [expressjs module](https://expressjs.com/).

#### **WS**

Modulo utilizzato per stabilire e gestire una connessione di tipo **WebSocket** sul server.

Repository del modulo: [ws module](https://github.com/websockets/ws).

#### **TypeScript**

TypeScript è un linguaggio di programmazione open-source basato su JavaScript, che aggiunge ad esso la **tipizzazione** delle variabili, in modo tale da fornire una documentazione e una struttura più **semplice e migliore**.

Sito ufficiale del linguaggio: [TypeScript](https://www.typescriptlang.org/).

## LICENZA

[MIT](LICENSE).
