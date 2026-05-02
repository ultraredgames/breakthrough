// Stop the ball.
if (speed > 0) {
	speed = 0;
	audio_play_sound(snd_zaball, 0, false);
} else if (speed == 0) {
	speed = 3;
}