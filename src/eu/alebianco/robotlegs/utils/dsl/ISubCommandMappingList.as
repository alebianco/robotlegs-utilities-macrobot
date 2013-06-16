/**
 * Author:  alessandro.bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 11/06/2013 14:50
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.dsl {
import eu.alebianco.robotlegs.utils.api.*;

public interface ISubCommandMappingList {
    function addMapping(mapping:ISubCommandMapping):void;

    function removeMapping(mapping:ISubCommandMapping):void;

    function removeMappingsFor(commandClass:Class):void;

    function removeAllMappings():void;

    function getList():Vector.<ISubCommandMapping>;
}
}
