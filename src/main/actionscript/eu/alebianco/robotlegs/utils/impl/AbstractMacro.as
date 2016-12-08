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
import eu.alebianco.robotlegs.utils.api.ISubCommandMapping;
import eu.alebianco.robotlegs.utils.dsl.ISubCommandConfigurator;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.applyHooks;
import robotlegs.bender.framework.impl.guardsApprove;

public class AbstractMacro extends AsyncCommand implements IMacro {

    [Inject]
    public var injector:IInjector;

    protected var mappings:SubCommandMappingList = new SubCommandMappingList();

    [PostConstruct]
    public function initialize():void {
        this.injector = injector.createChild();
        prepare();
    }

    public function add(commandClass:Class):ISubCommandConfigurator {
        const mapping:SubCommandMapping = new SubCommandMapping(commandClass);
        mappings.addMapping(mapping);
        return mapping;
    }

	public function addInstance(command : ICommand) : ISubCommandConfigurator {
		const mapping:SubCommandMapping = new SubCommandInstanceMapping(command);
		mappings.addMapping(mapping);
		return mapping;
	}

    public function remove(commandClass:Class):void {
        mappings.removeMappingsFor(commandClass);
    }

    public function prepare():void {
        throw new Error("method must be overridden");
    }

    override public function execute():void {
        super.execute();
    }

    protected function executeCommand(mapping:ISubCommandMapping):void {

        var command:ICommand;

        const commandClass:Class = mapping.commandClass;
        const payloads:Array = mapping.payloads;
        const hasPayloads:Boolean = payloads.length > 0;

        hasPayloads && mapPayloads(payloads);

        if (mapping.guards.length == 0 || guardsApprove(mapping.guards, injector)) {
            command = mapping.getOrCreateCommandInstance(injector);

            if (mapping.hooks.length > 0) {
                injector.map(commandClass).toValue(command);
                applyHooks(mapping.hooks, injector);
                injector.unmap(commandClass);
            }
        }

        hasPayloads && unmapPayloads(payloads);

        if (command && mapping.executeMethod) {
            const isAsync:Boolean = command is IAsyncCommand;
            isAsync && IAsyncCommand(command).registerCompleteCallback(commandCompleteHandler);
            const executeMethod:Function = command[mapping.executeMethod];
            executeMethod();
            isAsync || commandCompleteHandler(true);
        } else {
            commandCompleteHandler(true);
        }
    }

    protected function mapPayloads(payloads:Array):void {
        for each (var payload:SubCommandPayload in payloads) {
            injector.map(payload.type, payload.name).toValue(payload.data);
        }
    }

    protected function unmapPayloads(payloads:Array):void {
        for each (var payload:SubCommandPayload in payloads) {
            injector.unmap(payload.type, payload.name);
        }
    }

    protected function commandCompleteHandler(success:Boolean):void {
        throw new Error("method must be overridden");
    }
}
}
