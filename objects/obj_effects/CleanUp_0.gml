// Delete all effect entries.
var _next = __head;
while (_next) {
    var _entry = _next;
    _next = _entry.__next;
    delete _entry;
}

// Clean up infrastructure.
delete __named;
__named = undefined;
__head = undefined;
__tail = undefined;
