package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Pits extends Entity
{
    private var grid:Grid;
    private var tiles:Tilemap;

    public function new(grid:Grid) {
        super(0, 0);
        this.grid = grid;
        type = "pit";
        mask = grid;
        updateGraphic();
    }

    public function updateGraphic() {
        tiles = new Tilemap(
            'graphics/pits.png',
            grid.width, grid.height, grid.tileWidth, grid.tileHeight
        );
        for(tileX in 0...grid.columns) {
            for(tileY in 0...grid.rows) {
                if(grid.getTile(tileX, tileY)) {
                    tiles.setTile(tileX, tileY, 0);
                }
            }
        }
        graphic = tiles;
    }
}

