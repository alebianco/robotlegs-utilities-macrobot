/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.dsl {
import eu.alebianco.robotlegs.utils.api.IMacroMapping;

public class MacroMapping implements IMacroMapping {
    private var _commandClass:Class;

    private var _guards:Array = [];
    private var _payloads:Array = [];
    private var _hooks:Array = [];

    public function MacroMapping(commandClass:Class) {
        _commandClass = commandClass;
    }

    public function get commandClass():Class {
        return _commandClass;
    }

    public function get payloads():Array {
        return _payloads;
    }

    public function get guards():Array {
        return _guards;
    }

    public function get hooks():Array {
        return _hooks;
    }

    public function withPayloads(...payloads):IMacroMapping {
        _payloads = _payloads.concat.apply(null, payloads);
        return this;
    }

    public function withGuards(...guards):IMacroMapping {
        _guards = _guards.concat.apply(null, guards);
        return this;
    }

    public function withHooks(...hooks):IMacroMapping {
        _hooks = _hooks.concat.apply(null, hooks);
        return this;
    }
}
}