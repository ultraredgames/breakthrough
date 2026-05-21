/**
 * Represents an effect entry.
 * Keeps track of the hash, step method and interval of a running effect,
 * as well as the elapsed frames since the last call to the step method.
 * @param {real} _hash          The hash of the name of the effect, or `undefined` if the effect is not named.
 * @param {method} _step_method The method to run at every step.
 * @param {real} _interval      The interval before running the step method, in frames.
 */
function EffectEntry(_hash, _step_method, _interval) constructor
{
    if (_interval <= 0) {
        // Interval must be a positive non-zero number.
        throw $"Invalid effect interval {interval}.";
    }

    hash = _hash;
    step_method = _step_method;
    interval = _interval;
    elapsed = 0;

    // Maintain pointers to neighbouring linked list entries.
    __prev = undefined;
    __next = undefined;
}

/**
 * Serves as the abstract base class of all effects.
 */
function Effect() constructor
{
}
