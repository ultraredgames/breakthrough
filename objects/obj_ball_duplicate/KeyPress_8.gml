// DEBUG FUNCTION
// Stop ball
if (spd > 0) {
	spd = 0;
//	audio_play_sound(snd_zaball, 0, false);
} else if (spd == 0) {
	spd = BALL_TOP_SPEED;
}
