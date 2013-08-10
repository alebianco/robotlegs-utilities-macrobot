/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {
import eu.alebianco.robotlegs.utils.api.ISubCommandMapping;
import eu.alebianco.robotlegs.utils.dsl.ISubCommandConfigurator;

final internal class SubCommandMapping implements ISubCommandMapping, ISubCommandConfigurator {

    private var _commandClass:Class;
    private var _executeMethod:String = 'execute';

    private var _guards:Array = [];
    private var _payloads:Array = [];
    private var _hooks:Array = [];

    public function SubCommandMapping(commandClass:Class) {
        _commandClass = commandClass;
    }

    public function get commandClass():Class {
        return _commandClass;
    }

    public function get executeMethod():String {
        return _executeMethod;
    }

    public function get guards():Array {
        return _guards.slice();
    }

    public function get hooks():Array {
        return _hooks.slice();
    }

    public function get payloads():Array {
        return _payloads.slice();
    }

    public function withGuards(...guards):ISubCommandConfigurator {
        _guards = _guards.concat.apply(null, guards);
        return this;
    }

    public function withHooks(...hooks):ISubCommandConfigurator {
        _hooks = _hooks.concat.apply(null, hooks);
        return this;
    }

    public function withPayloads(...payloads):ISubCommandConfigurator {
        for each (var object:Object in payloads) {
            var payload:SubCommandPayload;
            if (object is SubCommandPayload) {
                payload = object as SubCommandPayload;
            } else {
                payload = new SubCommandPayload(object, object["constructor"])
            }
            _payloads.push(payload);
        }
        return this;
    }

    public function withExecuteMethod(name:String):ISubCommandConfigurator {
        _executeMethod = name;
        return this;
    }
}
}
