// Go to next level.
if (room == FINAL_LEVEL) {
	room_goto(BEGIN_LEVEL);
} else {
	room_goto_next();
}
//audio_play_sound(snd_powerup, 0, false);
instance_destroy();
