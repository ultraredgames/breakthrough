/**
 * Registers a new anonymous effect.
 * The effect will run every time its interval is reached, as long as
 * its step function returns `true`.
 * @param {any} scope          The scope the effect will run in.
 * @param {function} step_func The function to run at every step.
 * @param {real} interval      The interval before running the step function, in frames.
 */
function add(scope, step_func = undefined, interval = 1)
{
    // Build effect entry and add it to the linked list.
    __append_effect_entry(
        __make_effect_entry(undefined, scope, step_func, interval));
}

/**
 * Registers a new named effect.
 * The effect will run every time its interval is reached, as long as
 * its step function returns `true`.
 * If an effect with the same name is already registered, the new
 * effect will be ignored and the existing one will continue to run,
 * unless `replace_existing` is `true`, in which case the previously
 * registered effect will be dropped instead.
 * @param {string} name                   The name of the effect.
 * @param {any} scope                     The scope the effect will run in.
 * @param {bool} [replace_existing]=false `true` to replace an existing effect with the same name.
 * @param {function} [step_func]          The function to run at every step.
 * @param {real} interval                 The interval before running the step function, in frames.
 */
function add_named(
    name, scope, replace_existing = false,
    step_func = undefined, interval = 1)
{
    // TODO
}

/**
 * Appends specified effect entry to the linked list, and adds it to the
 * named entries structure if it is named.
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
    // otherwise clever usage of `other` would allow the step function tp
    // escape its scope, and provide it access to our internals, which we
    // still do not want.
    var _safe_step_method = method({
        _step_method
    }, function() {
        return _step_method();
    });

    // Build and return effect entry.
    return new EffectEntry(hash, _safe_step_method, interval);
}

/**
 * Removes specified effect entry from the linked list, and from the named
 * entries strcture if it is named. The effect entry itself is not deleted.
 * @param {struct.EffectEntry} entry The effect entry to remove.
 */
function __remove_effect_entry(entry)
{
    // Gather neighbouring entries for relinking.
    var _prev = entry.__prev;
    var _next = entry.__next;

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
}

// The structure holding the named effect entries.
__named = {};

// The head of the linked list of effect entries.
__head = undefined;

// The tail of the linked list of effect entries.
__tail = undefined;
