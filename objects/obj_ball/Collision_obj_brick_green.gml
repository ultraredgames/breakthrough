// Destroy brick
var _dir = direction - 180; // Get the direction back along the way the ball moved
// This loop will only run while a collision is detected
while (place_meeting(x, y, other)) {
	// Move the ball back along the direction it came from until no collision is detected
	x += lengthdir_x(1, _dir);
	y += lengthdir_y(1, _dir);
}
move_bounce_all(true); // Set the bounce angle
if (speed < 12) {
	speed += 0.1; // Make the ball faster
}
global.player_score += obj_brick_green.points; // Add to the score
audio_play_sound(snd_break, 0, false);
instance_destroy(other); // Other being the brick