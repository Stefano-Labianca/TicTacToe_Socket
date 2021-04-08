/**
 * ## Vector2D
 * 
 * La classe Vector2D viene utilizzata per racchiudere in un'unica variabile delle coordinate.
 */
export class Vector2D 
{   
    /** @type {number} */
    x: number;

    /** @type {number} */
    y: number;


    /**
     * @constructor
     * @param x ascissa 
     * @param y ordinata
     */
    constructor(x: number, y: number) 
    {
        this.x = x;
        this.y = y;
    }

}

