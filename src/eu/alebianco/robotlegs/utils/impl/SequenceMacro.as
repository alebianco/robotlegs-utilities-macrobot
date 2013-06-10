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

public class SequenceMacro extends AbstractMacro implements IMacro {

    private var executionIndex:uint;
    private var success:Boolean = true;
    private var running:Boolean = false;

    private var _atomic:Boolean = true;
    public function get atomic():Boolean {
        return _atomic;
    }
    public function set atomic(value:Boolean):void {
        if (!running) {
            _atomic = value;
        }
    }

    public function SequenceMacro(injector:Injector) {
        super(injector);
    }

    override public function execute():void {
        super.execute();
        running = true
        executionIndex = 0;
        executeNext();
    }

    protected function executeNext():void {
        if (hasCommands) {
            const mapping:IMacroMapping = commands[executionIndex++];
            const command:ICommand = prepareCommand(mapping);
            if (command) {
                executeCommand(command);
            } else {
                executeNext();
            }
        } else {
            dispatchComplete(success);
        }
    }

    private function get hasCommands():Boolean {
        return commands && executionIndex < commands.length;
    }

    override protected function commandCompleteHandler(success:Boolean):void {
        this.success &&= success;
        (_atomic || this.success) ? executeNext() : dispatchComplete(false);
    }

    override protected function dispatchComplete(success:Boolean):void {
        running = false;
        executionIndex = 0;
        super.dispatchComplete(success);
    }
}
}
