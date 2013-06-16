/**
 * Author:  alessandro.bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 12/06/2013 11:27
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {
import eu.alebianco.robotlegs.utils.api.ISubCommandMapping;
import eu.alebianco.robotlegs.utils.dsl.ISubCommandMappingList;

import flash.utils.Dictionary;

final internal class SubCommandMappingList implements ISubCommandMappingList {

    private var _mappings:Vector.<ISubCommandMapping> = new Vector.<ISubCommandMapping>;
    private var _mappingByCommand:Dictionary = new Dictionary(true);

    public function getList():Vector.<ISubCommandMapping> {
        return _mappings.concat();
    }

    public function addMapping(mapping:ISubCommandMapping):void {
        storeMapping(mapping);
    }

    public function removeMapping(mapping:ISubCommandMapping):void {
        deleteMapping(mapping);
    }

    public function removeMappingsFor(commandClass:Class):void {
        if (_mappingByCommand[commandClass]) {
            const list:Vector.<ISubCommandMapping> = _mappingByCommand[commandClass];
            var length:int = list.length;
            while (length--) {
                deleteMapping(list[length]);
            }
            delete _mappingByCommand[commandClass];
        }
    }

    public function removeAllMappings():void {
        if (_mappings.length > 0) {
            const list:Vector.<ISubCommandMapping> = _mappings.concat();
            var length:int = list.length;
            while (length--) {
                deleteMapping(list[length]);
            }
        }
    }

    private function storeMapping(mapping:ISubCommandMapping):void {
        if (!_mappingByCommand[mapping.commandClass]) {
            _mappingByCommand[mapping.commandClass] = new <ISubCommandMapping>[];
        }
        _mappingByCommand[mapping.commandClass].push(mapping);
        _mappings.push(mapping);
    }

    private function deleteMapping(mapping:ISubCommandMapping):void {
        if (_mappingByCommand[mapping.commandClass]) {
            _mappingByCommand[mapping.commandClass].splice(_mappings.indexOf(mapping), 1);
            if (_mappingByCommand[mapping.commandClass].length == 0) {
                delete _mappingByCommand[mapping.commandClass];
            }
        }
        _mappings.splice(_mappings.indexOf(mapping), 1);
    }
}
}
