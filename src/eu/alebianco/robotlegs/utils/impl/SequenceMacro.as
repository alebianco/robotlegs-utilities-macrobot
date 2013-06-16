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

public class SequenceMacro extends AbstractMacro implements IMacro {

    private var executionIndex:uint;

    private var success:Boolean = true;
    private var running:Boolean = false;

    private var commands:Vector.<ISubCommandMapping>;

    private var _atomic:Boolean = true;
    public function get atomic():Boolean {
        return _atomic;
    }

    public function set atomic(value:Boolean):void {
        if (!running) {
            _atomic = value;
        }
    }

    override public function execute():void {
        super.execute();
        running = true
        executionIndex = 0;
        commands = mappings.getList();
        executeNext();
    }

    protected function executeNext():void {
        if (hasCommands) {
            const mapping:ISubCommandMapping = commands[executionIndex++];
            executeCommand(mapping);
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
        super.dispatchComplete(success);
        running = false;
        this.success = true;
        executionIndex = 0;
        commands = null;
    }
}
}
