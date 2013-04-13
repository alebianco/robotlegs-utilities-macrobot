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

internal class AbstractMacro extends AsyncCommand implements IMacro {
    protected var commands:Vector.<IMacroMapping>;

    protected var success:Boolean = true;

    [Inject]
    public var injector:Injector;

    [PostConstruct]
    public function initialize():void {
        prepare();
    }

    public function prepare():void {
        throw new Error("method must be overridden");
    }

    public function addSubCommand(commandClass:Class):MacroMapping {
        var subcommand:MacroMapping = new MacroMapping(commandClass);

        commands ||= new Vector.<IMacroMapping>();
        commands.push(subcommand);

        return subcommand;
    }

    override public function execute():void {
        super.execute();
    }

    protected function executeCommand(command:ICommand):void {
        var isAsync:Boolean = command is IAsyncCommand;

        if (isAsync) {
            IAsyncCommand(command).addCompletionListener(commandCompleteHandler);
        }

        command.execute();

        if (!isAsync) {
            commandCompleteHandler(true);
        }
    }

    protected function prepareCommand(mapping:IMacroMapping):ICommand {
        var command:ICommand;

        if (mapping.payloads && mapping.payloads.length > 0) {
            var reflector:Reflector = new DescribeTypeReflector();

            var payload:SubCommandPayload
            var klass:Class;

            injector.map(mapping.commandClass).asSingleton();
            for each (payload in mapping.payloads) {
                klass = (payload.dataClass) ? payload.dataClass : reflector.getClass(payload.data);
                injector.map(klass, payload.name).toValue(payload.data);
            }

            command = injector.getInstance(mapping.commandClass);
            applyHooks(mapping.hooks, injector);

            injector.unmap(mapping.commandClass);
            for each (payload in mapping.payloads) {
                klass = (payload.dataClass) ? payload.dataClass : reflector.getClass(payload.data);
                injector.unmap(klass, payload.name);
            }
        }
        else {
            injector.map(mapping.commandClass).asSingleton();
            command = injector.getInstance(mapping.commandClass);
            applyHooks(mapping.hooks, injector);
            injector.unmap(mapping.commandClass);
        }

        return command;
    }

    protected function commandCompleteHandler(success:Boolean):void {
        throw new Error("method must be overridden");
    }
}
}