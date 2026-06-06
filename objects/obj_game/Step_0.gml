// Check room restart
if (instance_number(obj_brick_parent) - instance_number(obj_brick_gold) == 0) {
	if (room == FINAL_LEVEL) {
		global.high_score = global.player_score;
		room_goto(BEGIN_LEVEL);
	} else {
		room_goto_next();
	}
}