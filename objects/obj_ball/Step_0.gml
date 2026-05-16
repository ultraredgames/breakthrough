// Movement check
if (!moving) {
	// Ball isn't moving, so let's see if the game can be started by pressing "Space".
	if (keyboard_check_pressed(vk_space)) {
		// Set the ball speed, direction and the controller variable so this code won't run again.
		moving = true;
		speed = spd;
		direction = dir;
//		audio_play_sound(snd_click, 0, false);
	}
}
// Bounce logic
// Check if the ball is colliding with the left or right side of the room
if (bbox_left < GAME_AREA_LEFT || bbox_right > GAME_AREA_RIGHT) {
	// Make sure the ball stays within the room bounds
	x = clamp(x, sprite_get_xoffset(sprite_index),
		GAME_AREA_RIGHT - sprite_get_xoffset(sprite_index));
	hspeed *= -1;
	// With each bounce, increase the ball speed up to a limit of 12 pixels per frame
	if (speed < 16) {
		speed += 0.1333;
	}
//	audio_play_sound(snd_bounce, 0, false, 1, 0, random_range(0.3, 0.6));
	direction += 2 - random(4);
}
// Check if the ball is colliding with the top of the room
if (bbox_top < GAME_AREA_TOP) {
	vspeed *= -1;
	// With each bounce, increase the ball speed up to a limit of 12 pixels per frame
	if (speed < 16) {
		speed += 0.1333;
	}
//	audio_play_sound(snd_bounce, 0, false, 1, 0, random_range(0.3, 0.6));
	direction += 2 - random(4);
} else {
	// Check if the ball is leaving the bottom of the room
	// TODO - Respawn ball on the player object.
	if (bbox_bottom > room_height) {
		x = GAME_AREA_RIGHT / 2;
		y = room_height / 2;
//		direction = random(359);
	}
}