// Movement check
if (!moving) {
	// Ball isn't moving, so let's see if the game can be started by pressing "Space"
	if (keyboard_check_pressed(vk_space)) {
		// Set the ball speed, direction and the controller variable so this code won't run again
		moving = true;
		speed = spd;
		direction = dir;
//		audio_play_sound(snd_click, 0, false);
	}
}
