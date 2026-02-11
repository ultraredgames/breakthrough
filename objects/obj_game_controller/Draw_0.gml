// Draw text
if (room == rm_start) {
	// Draw the title text
	draw_set_font(fnt_title);

	// Draw game name
	draw_set_halign(fa_center);
	draw_text_transformed_colour(room_width / 2, 20, "BREAKTHROUGH", 3, 3, 0, c_white, c_white, c_white, c_white, 1);
	draw_text_transformed_colour(room_width / 2, room_height / 2, "PRESS ANY BUTTON", 1.5, 1.5, 0, c_yellow, c_yellow, c_yellow, c_yellow, 1);
	draw_set_halign(fa_left);
} else {
	// Draw values
	draw_set_colour(c_white);
	draw_set_font(fnt_game);
	
	// Draw the player score
	draw_set_halign(fa_left);
	draw_text(8, 8, "Score: " + string(global.player_score));

	// Draw the high score
	draw_set_halign(fa_right);
	draw_text(room_width - 8, 8, "Hi Score: " + string(global.high_score));

	// Draw the player lives as sprites
	var _x = (room_width / 2) - (32 * (global.player_lives - 1));

	repeat(global.player_lives) {
		draw_sprite_ext(spr_bat, 0, _x, room_height - 16, 0.75, 0.75, 1, c_white, 0.5);
		_x += 64;
	}
}