// The name of the room transition layer.
#macro ROOM_TRANSITION_LAYER "RoomTransitions"

// Fade direction.
enum FadeDirection
{
	Out,
	In
}

/**
 * Performs a fade effect while switching to specified room.
 * @param {asset.gmroom} room_index The index of the room to switch to.
 * @param {real} [duration]=180 The duration of the fade effect, in frames.
 * @param {constant.color} [color]=c_black The color to fade to or from.
 */
function fade_room_goto(room_index, duration = 30, color = c_black)
{
	if (instance_exists(obj_room_transition)) {
		// Another room transition is active, bail out.
		return;
	}
	
	if (room_index == noone) {
		// No room to switch to, do nothing.
		return;
	}
	if (duration <= 0) {
		// Negative or zero duration, switch right away.
		room_goto(room_index);
	}
	
	// Create room transition layer above everything else.
	if (!layer_exists(ROOM_TRANSITION_LAYER)) {
		layer_create(-100, ROOM_TRANSITION_LAYER);
	}
	
	// Create room transition object instance.
	var _obj = instance_create_layer(0, 0, ROOM_TRANSITION_LAYER,
		obj_room_transition_fade);
	_obj.room_index = room_index;
	_obj.duration = duration;
	_obj.fade_color = color;
}
