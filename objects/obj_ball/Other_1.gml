// Bounce Logic
// Check if the ball is "colliding" with the left or right side of the room
if (bbox_left < 0 || bbox_right > room_width) {
	// Make sure the ball stays within the room bounds
	x = clamp(x, sprite_get_xoffset(sprite_index), room_width - sprite_get_xoffset(sprite_index));
	hspeed *= -1;
}
// Check if the ball is "colliding" with the top of the room
if (bbox_top < 0) {
	vspeed *= -1;
} else {
	// Check if the ball is leaving the bottom of the room
	if (bbox_bottom > room_height) {
		global.player_lives -= 1;
		if (global.player_lives <= 0) {
			// Check for new highscore
			if (global.player_score > global.high_score) {
				global.high_score = global.player_score;
		    }
		    // Set controller state
		    with (obj_game_controller) {
				state ="GAMEOVER";
		    }
		} else {
			// Only create a new ball if the player has lives
		    instance_create_layer(xstart, ystart, layer, obj_ball);
			instance_destroy();
		}
	}
}
// With each bounce, increase the ball speed up to a maximum of 12px per step
if (speed < 12) {
	speed += 0.1;
}
//audio_play_sound(snd_bounce, 0, false);
direction += 2 - random(4);