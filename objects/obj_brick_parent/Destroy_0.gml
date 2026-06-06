// Powerup creation logic.
var _powerup = choose(obj_powerup_extend, obj_powerup_slow,	obj_powerup_duplicate,
	obj_powerup_player, obj_powerup_tension, obj_powerup_magnet, obj_powerup_catch, obj_powerup_laser, obj_powerup_beat); // Choose powerup object
//var _powerup = obj_powerup_tension; // Choose powerup object
if (irandom(2) == 0) {
	instance_create_layer(x, y, layer, _powerup);
}
