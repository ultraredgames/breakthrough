/**
 * Registers a new anonymous effect.
 * The effect will run every time its interval is reached, as long as its
 * step function returns `true`. If `step_func` is `undefined`, `_scope`
 * must expose a `step()` method, and that method will be called instead.
 * @param {any} scope            The scope the effect will run in.
 * @param {function} [step_func] The function to run at every step. Defaults to `undefined`.
 * @param {real} [interval]      The interval before running the step function, in frames. Defaults to `1`.
 */
function add(scope, step_func = undefined, interval = 1)
{
    // Build effect entry and add it to the linked list.
    __append_effect_entry(
        __make_effect_entry(undefined, scope, step_func, interval));
}

/**
 * Registers a new named effect.
 * The effect will run every time its interval is reached, as long as its
 * step function returns `true`. If `step_func` is `undefined`, `_scope`
 * must expose a `step()` method, and that method will be called instead.
 * If an effect with the same name is already registered, the new effect
 * will be ignored and the existing one will continue to run, unless
 * `replace_existing` is `true`, in which case the previously registered
 * effect will be discarded and replaced by the new one.
 * @param {string} name             The name of the effect.
 * @param {any} scope               The scope the effect will run in.
 * @param {function} [step_func]    The function to run at every step. Defaults to `undefined`.
 * @param {bool} [replace_existing] `true` to replace an existing effect with the same name. Defaults to `false`.
 * @param {real} [interval]         The interval before running the step function, in frames. Defaults to `1`.
 */
function add_named(
    name, scope, step_func = undefined,
    replace_existing = false, interval = 1)
{
    var _hash = variable_get_hash(name);
    var _existing_entry = struct_get_from_hash(__named, _hash);
    if (_existing_entry && !replace_existing) {
        // An effect with the same name is already registered and we must
        // not replace it, do nothing.
        return;
    }

    var _entry = __make_effect_entry(
        _hash, scope, step_func, interval);
    if (_existing_entry) {
        // Found existing effect entry, replace it.
        __replace_effect_entry(_existing_entry, _entry);
        delete _existing_entry;
    } else {
        // No existing effect entry, register the new one.
        __append_effect_entry(_entry);
    }
}

/**
 * Returns the number of effect entries managed by this instance.
 * @returns {real} The number of effect entries.
 */
function get_count()
{
    return __count;
}

/**
 * Unregisters and discards the effect with specified name.
 * The removed effect will never run again from this point onward.
 * @param {string} name The name of the effect to remove.
 */
function remove(name)
{
    var _entry = __named[$ name];
    if (_entry) {
        __remove_effect_entry(_entry);
        delete _entry;
    }
}

/**
 * Appends specified effect entry to the linked list, and adds it to the
 * named entries structure if the effect is named.
 * @param {struct.EffectEntry} entry The effect entry to append.
 */
function __append_effect_entry(entry)
{
    if (__tail) {
        // Linked list is not empty, append effect entry.
        entry.__prev = __tail;
        __tail.__next = entry;
        __tail = entry;
    } else {
        // Linked list is empty, initialize.
        __head = entry;
        __tail = entry;
    }

    if (!is_undefined(entry.hash)) {
        // Effect is named, add entry to the named entries structure.
        struct_set_from_hash(__named, entry.hash, entry);
    }

    // Update effect entry count.
    ++__count;
}

/**
 * Initializes a new effect entry structure.
 * @param {real} hash            The hash of the name of the effect, or `undefined` if the effect is not named.
 * @param {any} scope            The scope the effect will run in.
 * @param {function} step_func   The function to run at every step.
 * @param {real} interval        The interval before running the step function, in frames.
 * @returns {struct.EffectEntry} The new effect entry.
 */
function __make_effect_entry(hash, scope, step_func, interval)
{
    // If `scope` is `undefined` or `null_pointer`, `step_func` will run
    // in the effect entry's scope, which we do not want as it gives the
    // step function direct access to our internals. Fall back to an empty
    // scope instead.
    var _scope = scope ?? {};

    // Compute the step method to run. If `step_func` was specified,
    // bind it to `_scope`, otherwise fall back to the `step()` method
    // of `_scope` itself. This will rightfully crash if `step_func` is
    // not specified and `_scope` does not expose a `step()` method.
    var _step_method = step_func ? method(_scope, step_func) : _scope.step;

    // We now have to "sandbox" the step method into its own caller scope,
    // otherwise clever usage of `other` would allow the step function to
    // escape its scope, and provide it access to our internals, which we
    // still do not want.
    var _safe_step_method = method({
        _step_method
    }, function() {
        return _step_method();
    });

    // Build and return effect entry.
    return new EffectEntry(self, hash, _safe_step_method, interval);
}

/**
 * Removes specified effect entry from the linked list, and from
 * the named entries structure if the effect is named.
 * The effect entry itself is not deleted.
 * @param {struct.EffectEntry} entry The effect entry to remove.
 */
function __remove_effect_entry(entry)
{
    if (!entry.__owner) {
        // This happens when an effect entry is replaced or removed,
        // then returns `false` from its step function in the same frame.
        // This pattern is so common in my early tests that I'm strongly
        // inclined to allow it.
        return;
    }

    // Gather neighbouring entries for relinking.
    var _prev = entry.__prev;
    var _next = entry.__next;

    // Reset entry to remove.
    entry.__owner = undefined;
    entry.__prev = undefined;
    entry.__next = undefined;

    if (entry == __head) {
        // Entry is the head of the linked list, so that should point
        // to its successor instead.
        __head = _next;
    }
    if (entry == __tail) {
        // Entry is the tail of the linked list, so that should point
        // to its predecessor instead.
        __tail = _prev;
    }

    if (_prev) {
        // Entry has a predecessor, its successor should become the
        // entry's successor.
        _prev.__next = _next;
    }
    if (_next) {
        // Entry has a successor, its predecessor should become the
        // entry's predecessor.
        _next.__prev = _prev;
    }

    if (!is_undefined(entry.hash)) {
        // Effect is named, remove entry from the named entries structure.
        struct_remove_from_hash(__named, entry.hash);
    }

    // Update effect entry count.
    --__count;
}

/**
 * Replaces an existing effect entry in the linked list with a new entry.
 * Adds the new entry to the named entries structure if the effect is named.
 * The new effect entry must not already be part of the linked list.
 * Both effects must either be anonymous or share the same name.
 * The replaced effect entry is not deleted.
 * @param {struct.EffectEntry} existing_entry The effect entry to replace.
 * @param {struct.EffectEntry} new_entry      The new effect entry.
 */
function __replace_effect_entry(existing_entry, new_entry)
{
    // Gather neighbours of existing entry for relinking.
    var _prev = existing_entry.__prev;
    var _next = existing_entry.__next;

    // Reset existing entry.
    existing_entry.__owner = undefined;
    existing_entry.__prev = undefined;
    existing_entry.__next = undefined;

    // New entry must now reference these neighbours.
    new_entry.__prev = _prev;
    new_entry.__next = _next;

    if (existing_entry == __head) {
        // Existing entry is the head of the linked list, so that should
        // point to the new entry instead.
        __head = new_entry;
    }
    if (existing_entry == __tail) {
        // Existing entry is the tail of the linked list, so that should
        // point to the new entry instead.
        __tail = new_entry;
    }

    if (_prev) {
        // Existing entry has a predecessor, its successor should become
        // the new entry.
        _prev.__next = new_entry;
    }
    if (_next) {
        // Existing entry has a successor, its predecessor should become
        // the new entry.
        _next.__prev = new_entry;
    }

    if (!is_undefined(new_entry.hash)) {
        // New effect is named, add entry to the named entries structure.
        struct_set_from_hash(__named, new_entry.hash, new_entry);
    }
}

// The structure holding the named effect entries.
__named = {};

// The head of the linked list of effect entries.
__head = undefined;

// The tail of the linked list of effect entries.
__tail = undefined;

// The number of effect entries in the linked list.
__count = 0;
