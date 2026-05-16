// Draw values
draw_set_colour(c_white);
draw_set_font(fnt_game);

// Draw player score
draw_set_halign(fa_left);
draw_text(GAME_HUD_LEFT, GAME_HUD_TOP, "Score: " + string(global.player_score));

// Draw high score
draw_text(GAME_HUD_LEFT, GAME_HUD_TOP + TILE_SIZE,
	"Hi Score: " + string(global.high_score));

// Draw the player lives as sprites
var _x = GAME_HUD_LEFT + TILE_SIZE;

repeat(global.player_lives) {
	draw_sprite_ext(spr_player, 0, _x, room_height - TILE_SIZE, 0.75, 0.75, 0,
		c_white, 0.625);
	_x += BRICK_WIDTH * 2;
}
