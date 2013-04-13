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

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.impl.guardsApprove;

public class SequenceMacro extends AbstractMacro implements IMacro {
    public var atomic:Boolean = true;

    protected var executionIndex:uint;

    override public function execute():void {
        super.execute();
        executionIndex = 0;
        executeNext();
    }

    protected function executeNext():void {
        if (commands && executionIndex < commands.length) {
            var mapping:IMacroMapping = commands[executionIndex++];
            if (guardsApprove(mapping.guards, injector)) {
                var command:ICommand = prepareCommand(mapping);
                executeCommand(command);
            }
            else {
                executeNext();
            }
        }
        else {
            dispatchComplete(success);
        }
    }

    override protected function commandCompleteHandler(success:Boolean):void {
        this.success &&= success;
        (atomic || this.success) ? executeNext() : dispatchComplete(false);
    }
}
}