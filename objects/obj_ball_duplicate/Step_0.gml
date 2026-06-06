speed = spd;
// Bounce logic
// Check if the ball is colliding with the left or right side of the room
if (bbox_left < GAME_AREA_LEFT || bbox_right > GAME_AREA_RIGHT) {
	// Make sure the ball stays within the room bounds
	x = clamp(x, sprite_get_xoffset(sprite_index),
		GAME_AREA_RIGHT - sprite_get_xoffset(sprite_index));
	hspeed *= -1;
//	audio_play_sound(snd_bounce, 0, false, 1, 0, random_range(0.3, 0.6));
	direction += 2 - random(4);
}
// Check if the ball is colliding with the top of the room.
if (bbox_top < GAME_AREA_TOP) {
	vspeed *= -1;
//	audio_play_sound(snd_bounce, 0, false, 1, 0, random_range(0.3, 0.6));
	direction += 2 - random(4);
} else {
	// Check if the ball is leaving the bottom of the room.
	if (bbox_bottom > room_height + TILE_SIZE * 2) {
		instance_destroy();
	}
}