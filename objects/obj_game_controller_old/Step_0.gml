// Check room restart
if (room != rm_start_old) {
	if (instance_number(obj_brick_old) - instance_number(obj_brick_gold_old) == 0) {
		if (room == rm_lvl003_old) {
			global.high_score = global.player_score;
			room_goto(rm_lvl001_old);
		} else {
			room_goto_next();
		}
	} else {
		if (state == "GAMEOVER") {
			if keyboard_check(vk_anykey) {
				//audio_play_sound(snd_click, 0, false);
				global.player_score = 0;
				global.player_lives = 3;
				room_restart();
			}
		}
	}
}