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
import eu.alebianco.robotlegs.utils.api.ISubCommandMapping;

public class ParallelMacro extends AbstractMacro implements IMacro {

    protected var executionCount:uint = 0;

    protected var commands:Vector.<ISubCommandMapping>;

    protected var success:Boolean = true;
    protected var running:Boolean = false;

    override public function execute():void {
        super.execute();
        commands = mappings.getList();
        if (hasCommands) {
            running = true;
            for each (var mapping:ISubCommandMapping in commands) {
                if (!success) break;
                executeCommand(mapping);
            }
        } else {
            dispatchComplete(true);
        }
    }

    protected function get hasCommands():Boolean {
        return mappings && commands.length > 0;
    }

    override protected function commandCompleteHandler(success:Boolean):void {
        executionCount++;
        this.success &&= success;
        if (running && (!this.success || executionCount == commands.length)) {
            dispatchComplete(this.success);
        }
    }

    override protected function dispatchComplete(success:Boolean):void {
        super.dispatchComplete(success);
        running = false;
        this.success = true;
        executionCount = 0;
        commands = null;
    }
}
}
