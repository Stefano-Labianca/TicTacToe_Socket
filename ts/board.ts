import { Vector2D } from './utility/Vector2D';

const MAX_PLAYERS: number = 2;
const cells_position: Map<string, Vector2D> = new Map<string, Vector2D>([
    ['(0, 0)', new Vector2D(0, 0)],
    ['(1, 0)', new Vector2D(1, 0)],
    ['(2, 0)', new Vector2D(2, 0)],

    ['(0, 1)', new Vector2D(0, 1)],
    ['(1, 1)', new Vector2D(1, 1)],
    ['(2, 1)', new Vector2D(2, 1)],

    ['(0, 2)', new Vector2D(0, 2)],
    ['(1, 2)', new Vector2D(1, 2)],
    ['(2, 2)', new Vector2D(2, 2)],
]);


var game_board: Array<Array<number>> = [[-1, -1, -1], [-1, -1, -1], [-1, -1, -1]];
var round: number = 0
