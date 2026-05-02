// Powerup creation logic
var _powerup = choose(obj_powerup_extend, obj_powerup_slow); // Choose powerup object
if (irandom(2) == 0) {
	instance_create_layer(x, y, layer, _powerup);
}
