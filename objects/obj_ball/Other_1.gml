// Bounce logic
// Check if the ball is colliding with the left or right side of the room
// FIXME
if (bbox_left < 0 || bbox_right > room_width) {
	// Make sure the ball stays within the room bounds
	x = clamp(x, sprite_get_xoffset(sprite_index), room_width - sprite_get_xoffset(sprite_index));
	hspeed *= -1;
}
// Check if the ball is colliding with the top of the room
// FIXME
if (bbox_top < 0) {
	vspeed *= -1;
} else {
	// Check if the ball is leaving the bottom of the room
	if (bbox_bottom > room_height) {
		x = room_width / 2;
		y = room_height / 2;
		direction = random(359)
	}
}
// With each bounce, increase the ball speed up to a limit of 12 pixels per frame
if (speed < 12) {
	speed += 0.1;
}
//audio_play_sound(snd_bounce, 0, false, 1, 0, random_range(0.3, 0.6));
direction += 2 - random(4);
