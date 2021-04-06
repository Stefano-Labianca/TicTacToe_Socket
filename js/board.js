"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Vector2D_1 = require("./utility/Vector2D");
const MAX_PLAYERS = 2;
var cells_position = new Map([
    ['(0, 0)', new Vector2D_1.Vector2D(0, 0)],
    ['(0, 1)', new Vector2D_1.Vector2D(0, 1)],
]);
var game_board = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
var round = 0;
