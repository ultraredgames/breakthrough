// Check room restart
if (instance_number(obj_brick_white) <= 0) {
if (instance_number(obj_brick_red) <= 0) {
if (instance_number(obj_brick_green) <= 0) {
if (instance_number(obj_brick_blue) <= 0) {
if (instance_number(obj_brick_orange) <= 0) {
if (instance_number(obj_brick_yellow) <= 0) {
if (instance_number(obj_brick_fuchsia) <= 0) {
if (instance_number(obj_brick_metal) <= 0) {
if (room == rm_lvl002) {
	room_goto(rm_lvl001);
} else {
	room_goto_next();
}}}}}}}}} else {
	if (state == "GAMEOVER") {
		if keyboard_check(vk_anykey) {
			//audio_play_sound(snd_click, 0, false);
			global.player_score = 0;
			global.player_lives = 3;
			room_restart();
		}
	}
}