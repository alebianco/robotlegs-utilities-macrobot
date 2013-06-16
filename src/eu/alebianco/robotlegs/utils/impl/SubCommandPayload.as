/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {
import org.swiftsuspenders.reflection.DescribeTypeReflector;
import org.swiftsuspenders.reflection.Reflector;

final public class SubCommandPayload {
    private var _data:*;
    private var _type:Class;
    private var _name:String;

    private static var _reflector:Reflector;
    private function get reflector():Reflector {
        return _reflector ||= new DescribeTypeReflector();
    }

    public function SubCommandPayload(data:*, type:Class = null) {
        if (!data) throw new ArgumentError("Payload data can't be null");
        _data = data;
        _type = type;
    }

    public function get name():String {
        return _name;
    }

    public function get type():Class {
        return _type ||= reflector.getClass(data);
    }

    public function get data():* {
        return _data;
    }

    public function withName(name:String):SubCommandPayload {
        _name = name;
        return this;
    }

    public function ofClass(type:Class):SubCommandPayload {
        _type = type
        return this;
    }
}
}
