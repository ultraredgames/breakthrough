// The width and height of a tile, in pixels.
#macro TILE_SIZE 24

// The number of bricks in a row.
#macro BRICKS_PER_ROW 13

// The width of a brick, in pixels.
#macro BRICK_WIDTH (TILE_SIZE * 2)

// The height of a brick, in pixels.
#macro BRICK_HEIGHT TILE_SIZE

// The left edge of the game area, in pixels.
#macro GAME_AREA_LEFT TILE_SIZE

// The top edge of the game area, in pixels.
#macro GAME_AREA_TOP TILE_SIZE

// The width of the game area, in pixels.
#macro GAME_AREA_WIDTH (BRICK_WIDTH * BRICKS_PER_ROW)

// The right edge of the game area, in pixels.
#macro GAME_AREA_RIGHT (GAME_AREA_LEFT + GAME_AREA_WIDTH)

// The left edge of the HUD, in pixels.
#macro GAME_HUD_LEFT (GAME_AREA_RIGHT + TILE_SIZE * 2)

// The top edge of the HUD, in pixels.
#macro GAME_HUD_TOP TILE_SIZE
