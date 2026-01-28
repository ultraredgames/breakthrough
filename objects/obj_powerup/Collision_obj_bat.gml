// Powerup Logic
// Check to see what frame is being used by the sprite
switch(image_index) {
	case 0: // Expand the bat
	with (obj_bat) {
		image_xscale = 1.5;
		alarm[0] = 60 * 10;
	}
	break;
	case 1: // Slow down the ball
	with (obj_ball) {
		speed = spd;
	}
	break;
}
instance_destroy();