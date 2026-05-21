// Iterate over all effect entries.
var _next = __head;
while(_next) {
    var _entry = _next;
    _next = _entry.__next;
    if (++_entry.elapsed >= _entry.interval) {
        // Interval reached, reset counter and call step method for this effect.
        _entry.elapsed = 0;
        if (!_entry.step_method()) {
            // Step method returned false, discard effect entry.
            __remove_effect_entry(_entry);
            delete _entry;
        }
    }
}
