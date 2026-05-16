// Restart level.
if (room = rm_gameover) {
	if keyboard_check(vk_anykey) {
		//audio_play_sound(snd_click, 0, false);
		global.player_score = 0;
		global.player_lives = 3;
		room_goto(rm_level_001);
	}
}