/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
\ *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {

import eu.alebianco.robotlegs.utils.api.IAsyncCommand;
import eu.alebianco.robotlegs.utils.api.IMacro;
import eu.alebianco.robotlegs.utils.api.IMacroMapping;
import eu.alebianco.robotlegs.utils.dsl.MacroMapping;

import org.swiftsuspenders.Injector;
import org.swiftsuspenders.reflection.DescribeTypeReflector;
import org.swiftsuspenders.reflection.Reflector;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.impl.applyHooks;
import robotlegs.bender.framework.impl.guardsApprove;

internal class AbstractMacro extends AsyncCommand implements IMacro {

    private var _commands:Vector.<IMacroMapping>;

    protected var injector:Injector;
    protected var reflector:Reflector = new DescribeTypeReflector();

    protected function get commands():Vector.<IMacroMapping> {
        return _commands ||= new Vector.<IMacroMapping>();
    }

    public function AbstractMacro(injector:Injector) {
        this.injector = injector.createChildInjector();
    }

    [PostConstruct]
    public function initialize():void {
        prepare();
    }

    public function prepare():void {
        throw new Error("method must be overridden");
    }

    // TODO create class to manage list, implement removeSubCommand and removeAllSubCommands
    public function addSubCommand(commandClass:Class):MacroMapping {
        var subcommand:MacroMapping = new MacroMapping(commandClass);
        commands.push(subcommand);
        return subcommand;
    }

    override public function execute():void {
        super.execute();
    }

    protected function executeCommand(command:ICommand):void {
        const isAsync:Boolean = command is IAsyncCommand;
        isAsync && IAsyncCommand(command).addCompletionListener(commandCompleteHandler);
        command.execute();
        isAsync || commandCompleteHandler(true);
    }

    protected function prepareCommand(mapping:IMacroMapping):ICommand {
        var command:ICommand;

        const commandClass:Class = mapping.commandClass;
        const payloads:Array = mapping.payloads;
        const hasPayloads:Boolean = payloads.length > 0;

        hasPayloads && mapPayloads(payloads);
        if (mapping.guards.length == 0 || guardsApprove(mapping.guards, injector)) {
            command = injector.getOrCreateNewInstance(commandClass);
            if (mapping.hooks.length > 0) {
                injector.map(commandClass).toValue(command);
                applyHooks(mapping.hooks, injector);
                injector.unmap(commandClass);
            }
        }
        hasPayloads && unmapPayloads(payloads);
        return command;
    }

    protected function mapPayloads(payloads:Array):void {
        for each (var payload:SubCommandPayload in payloads) {
            const dataClass:Class = (payload.dataClass) ? payload.dataClass : reflector.getClass(payload.data);
            injector.map(dataClass, payload.name).toValue(payload.data);
        }
    }
    protected function unmapPayloads(payloads:Array):void {
        for each (var payload:SubCommandPayload in payloads) {
            const dataClass:Class = (payload.dataClass) ? payload.dataClass : reflector.getClass(payload.data);
            injector.unmap(dataClass, payload.name);
        }
    }

    protected function commandCompleteHandler(success:Boolean):void {
        throw new Error("method must be overridden");
    }
}
}
