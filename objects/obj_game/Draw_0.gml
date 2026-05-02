// Draw values
draw_set_colour(c_white);
draw_set_font(fnt_game);
	
// Draw the player score
// TODO
draw_set_halign(fa_right);
draw_text(room_width - 8, 8, "Score: 000000");

// Draw the high score
// TODO
draw_set_halign(fa_right);
draw_text(room_width - 8, 32, "High Score: 000000");

// Draw the player lives as sprites
//var _x = (room_width / 2) - (32 * (3 - 1));

//repeat(3) {
//	draw_sprite_ext(spr_player, 0, 674, room_height - 32, 0.75, 0.75, 0, c_white, 0.5);
//	_x += 96;
//}
