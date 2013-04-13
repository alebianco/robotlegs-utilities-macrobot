/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {
public class SubCommandPayload {
    private var _data:*;
    private var _dataClass:Class;
    private var _name:String;

    public function SubCommandPayload(data:* = null) {
        _data = data;
    }

    public function get name():String {
        return _name;
    }

    public function get dataClass():Class {
        return _dataClass;
    }

    public function get data():* {
        return _data;
    }

    public function withName(name:String):SubCommandPayload {
        _name = name;
        return this;
    }

    public function fromClass(dataClass:Class):SubCommandPayload {
        _dataClass = dataClass
        return this;
    }
}
}