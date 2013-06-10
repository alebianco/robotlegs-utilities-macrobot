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

import org.swiftsuspenders.Injector;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public class ParallelMacro extends AbstractMacro implements IMacro {

    private var executionCount:uint = 0;
    private var success:Boolean = true;
    private var running:Boolean = false;

    public function ParallelMacro(injector:Injector) {
        super(injector);
    }

    override public function execute():void {
        super.execute();
        if (hasCommands) {
            running = true;
            for each (var mapping:IMacroMapping in commands) {
                if (!success) break;
                const command:ICommand = prepareCommand(mapping);
                if (command) {
                    executeCommand(command);
                }
            }
        } else {
            dispatchComplete(true);
        }
    }

    private function get hasCommands():Boolean {
        return commands && commands.length > 0;
    }

    override protected function commandCompleteHandler(success:Boolean):void {
        executionCount++;
        this.success &&= success;
        // TODO may receive other calls after dispatching the complete ?
        if (!this.success || executionCount == commands.length) {
            dispatchComplete(this.success);
        }
    }

    override protected function dispatchComplete(success:Boolean):void {
        running = false;
        executionCount = 0;
        super.dispatchComplete(success);
    }
}
}
