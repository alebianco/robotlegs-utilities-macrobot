/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.api {
public interface IMacroMapping {
    function withPayloads(...payloads):IMacroMapping;

    function withGuards(...guards):IMacroMapping;

    function withHooks(...hooks):IMacroMapping;

    function get commandClass():Class;

    function get guards():Array;

    function get hooks():Array;

    function get payloads():Array;
}
}