/**
 * Represents an effect entry.
 * Keeps track of the owner, hash, step method and interval of a running effect,
 * as well as the elapsed frames since the last call to the step method.
 * @param {asset.gmobject} _owner The instance of `obj_effects` that owns the effect entry.
 * @param {real} _hash            The hash of the name of the effect, or `undefined` if the effect is not named.
 * @param {function} _step_method The method to run at every step.
 * @param {real} _interval        The interval before running the step method, in frames.
 */
function EffectEntry(_owner, _hash, _step_method, _interval) constructor
{
    if (_interval <= 0) {
        // Interval must be a positive non-zero number.
        throw $"Invalid effect interval {_interval}.";
    }

    hash = _hash;
    step_method = _step_method;
    interval = _interval;
    elapsed = 0;

    // Maintain references to owner instance and neighbouring linked list entries.
    __owner = _owner;
    __prev = undefined;
    __next = undefined;
}

/**
 * Serves as the abstract base class of all effects.
 */
function Effect() constructor
{
}

/**
 * An effect that animates a set of variables for specified duration.
 * @param {real} _duration The duration of the animation, in steps.
 * @param {any} _variables The struct holding the variables to animate.
 * @param {any} [_context] The context provided to the step function. Defaults to `undefined`.
 */
function Animation(_duration, _variables, _context = undefined)
: Effect() constructor
{
    if (_duration <= 0) {
        // Duration must be a positive non-zero number.
        throw $"Invalid animation duration {_duration}.";
    }

    duration = _duration;
    variables = _variables;
    context = _context;
    elapsed = 0;

    // Initialize the variables to animate.
    var _easing_hash = variable_get_hash("easing");
    struct_foreach(variables, method({
        _easing_hash
    }, function(_, _variable) {
        _variable.value = _variable.from;
        if (!struct_get_from_hash(_variable, _easing_hash)) {
            // No easing function specified, fall back to `linear`.
            struct_set_from_hash(
                _variable, _easing_hash, global.Easing.linear);
        }
    }));

    /**
     * Computes the current values of all the animated variables
     * and determines whether the animation should stop.
     */
    static step = function() {
        // Compute current variable values.
        ++elapsed;
        var _progress = elapsed / duration;
        struct_foreach(variables, method({
            _progress
        }, function(_, _variable) {
            // Apply easing function, then interpolate linearly
            // into our target range.
            _variable.value = lerp(_variable.from, _variable.to,
                _variable.easing(_progress));
        }));

        // Stop animation when duration is reached.
        return elapsed < duration;
    };
}

// Holds the easing functions used by animations.
// These functions are ported from https://easings.net/.
global.Easing = {
    // Magic numbers from the original implementation.
    __c1: 1.70158,
    __c2: 1.70158 * 1.525,
    __c3: 1.70158 + 1,
    __c4: pi * 2 / 3,
    __c5: pi * 2 / 4.5,
    __d1: 2.75,
    __n1: 7.5625,

    linear: function(x) {
        return x;
    },

    in_sine: function(x) {
        return 1 - cos(x * pi / 2);
    },

    out_sine: function(x) {
        return sin(x * pi / 2);
    },

    in_out_sine: function(x) {
        return -(cos(x * pi) - 1) / 2;
    },

    in_quad: function(x) {
        return x * x;
    },

    out_quad: function(x) {
        return 1 - (1 - x) * (1 - x);
    },

    in_out_quad: function(x) {
        return x < 0.5 ? 2 * x * x
            : 1 - power(-2 * x + 2, 2) / 2;
    },

    in_cubic: function(x) {
        return x * x * x;
    },

    out_cubic: function(x) {
        return 1 - power(1 - x, 3);
    },

    in_out_cubic: function(x) {
        return x < 0.5 ? 4 * x * x * x
            : 1 - power(-2 * x + 2, 3) / 2;
    },

    in_quart: function(x) {
        return x * x * x * x;
    },

    out_quart: function(x) {
        return 1 - power(1 - x, 4);
    },

    in_out_quart: function(x) {
        return x < 0.5 ? 8 * x * x * x * x
            : 1 - power(-2 * x + 2, 4) / 2;
    },

    in_quint: function(x) {
        return x * x * x * x * x;
    },

    out_quint: function(x) {
        return 1 - power(1 - x, 5);
    },

    in_out_quint: function(x) {
        return x < 0.5 ? 16 * x * x * x * x * x
            : 1 - power(-2 * x + 2, 5) / 2;
    },

    in_expo: function(x) {
        return x == 0 ? 0 : power(2, 10 * x - 10);
    },

    out_expo: function(x) {
        return x == 1 ? 1 : 1 - power(2, -10 * x);
    },

    in_out_expo: function(x) {
        return (
            x == 0 ? 0
            : (x == 1 ? 1
            : (x < 0.5 ? power(2, 20 * x - 10) / 2
            : (2 - power(2, -20 * x + 10)) / 2)));
    },

    in_circ: function(x) {
        return 1 - sqrt(1 - power(x, 2));
    },

    out_circ: function(x) {
        return sqrt(1 - power(x - 1, 2));
    },

    in_out_circ: function(x) {
        return x < 0.5 ? (1 - sqrt(1 - power(2 * x, 2))) / 2
            : (sqrt(1 - power(-2 * x + 2, 2)) + 1) / 2;
    },

    in_back: function(x) {
        return __c3 * x * x * x - __c1 * x * x;
    },

    out_back: function(x) {
        return 1 + __c3 * power(x - 1, 3) + __c1 * power(x - 1, 2);
    },

    in_out_back: function(x) {
        return x < 0.5 ? power(2 * x, 2) * ((__c2 + 1) * 2 * x - __c2) / 2
            : (power(2 * x - 2, 2) * ((__c2 + 1) * (x * 2 - 2) + __c2) + 2) / 2;
    },

    in_elastic: function(x) {
        return (
            x == 0 ? 0
            : (x == 1 ? 1
            : -power(2, 10 * x - 10) * sin((x * 10 - 10.75) * __c4)));
    },

    out_elastic: function(x) {
        return (
            x == 0 ? 0
            : (x == 1 ? 1
            : power(2, -10 * x) * sin((x * 10 - 0.75) * __c4) + 1));
    },

    in_out_elastic: function(x) {
        return (
            x == 0 ? 0
            : (x == 1 ? 1
            : (x < 0.5 ? -power(2, 20 * x - 10) * sin((20 * x - 11.125) * __c5) / 2
            : power(2, -20 * x + 10) * sin((20 * x - 11.125) * __c5) / 2 + 1)));
    },

    in_bounce: function(x) {
        return 1 - out_bounce(1 - x);
    },

    out_bounce: function(x) {
        if (x < 1 / __d1) {
            return __n1 * x * x;
        } else if (x < 2 / __d1) {
            x -= 1.5 / __d1;
            return __n1 * x * x + 0.75;
        } else if (x < 2.5 / __d1) {
            x -= 2.25 / __d1;
            return __n1 * x * x + 0.9375;
        } else {
            x -= 2.625 / __d1;
            return __n1 * x * x + 0.984375;
        }
    },

    in_out_bounce: function(x) {
        return x < 0.5 ? (1 - out_bounce(1 - 2 * x)) / 2
            : (1 + out_bounce(2 * x - 1)) / 2;
    }
};
