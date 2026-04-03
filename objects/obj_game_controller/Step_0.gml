// Check room restart
if (room != rm_start) {
	if (instance_number(obj_brick) - instance_number(obj_brick_gold) == 0) {
		if (room == rm_lvl003) {
			room_goto(rm_lvl001);
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