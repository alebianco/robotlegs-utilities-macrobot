/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.api {
public interface ISubCommandMapping {
    function get commandClass():Class;

    function get executeMethod():String;

    function get guards():Array;

    function get hooks():Array;

    function get payloads():Array;
}
}
