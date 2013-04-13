/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {

import eu.alebianco.robotlegs.utils.api.IMacro;
import eu.alebianco.robotlegs.utils.api.IMacroMapping;
import eu.alebianco.robotlegs.utils.dsl.MacroMapping;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.impl.guardsApprove;

public class ParallelMacro extends AbstractMacro implements IMacro {
    protected var numCommandsExecuting:uint = 0;

    override public function execute():void {
        super.execute();

        var approvedCommands:Vector.<IMacroMapping> = findApprovedCommands(commands);
        if (approvedCommands && approvedCommands.length > 0) {
            numCommandsExecuting = approvedCommands.length;
            for each (var descriptor:Object in approvedCommands) {
                var command:ICommand = prepareCommand(descriptor as MacroMapping);
                success ? executeCommand(command) : dispatchComplete(false);
            }
        }
        else {
            dispatchComplete(true);
        }
    }

    protected function findApprovedCommands(mappings:Vector.<IMacroMapping>):Vector.<IMacroMapping> {
        const approvedMappings:Vector.<IMacroMapping> = new Vector.<IMacroMapping>();
        for each (var mapping:IMacroMapping in mappings) {
            if (guardsApprove(mapping.guards, injector))
                approvedMappings.push(mapping);
        }
        return approvedMappings;
    }

    override protected function commandCompleteHandler(success:Boolean):void {
        this.success &&= success;
        numCommandsExecuting--;

        if (numCommandsExecuting == 0) {
            dispatchComplete(this.success);
        }
    }
}
}