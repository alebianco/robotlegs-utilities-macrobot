/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 13/04/13 11.46
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;

import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.extensions.commandCenter.impl.CommandMapping;
import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.Context;
import robotlegs.bender.framework.impl.RobotlegsInjector;

public class PayloadsTest {

    private var injector:IInjector;
    private var mappings:Vector.<ICommandMapping>;
    private var dispatcher:IEventDispatcher;
    private var subject:IEventCommandMap;
    private var reported:Array;

    private function reportingFunction(item:Object):void {
        reported.push(item);
    }

    private function addMapping(commandClass:Class):ICommandMapping {
        var mapping:ICommandMapping = new CommandMapping(commandClass);
        mappings.push(mapping);
        return mapping;
    }

    [Before]
    public function before():void {
        reported = [];
        injector = new RobotlegsInjector();
        const context:IContext = new Context();
        injector = context.injector;
        injector.map(Function, "reportingFunction").toValue(reportingFunction);
        dispatcher = new EventDispatcher();
        subject = new EventCommandMap(context, dispatcher);
    }

    [After]
    public function after():void {
        injector = null;
    }

    [Test]
    public function payload_instances_are_mapped():void {
        subject.map("trigger", Event).toCommand(MacroWithNamedPayload);
        const event:Event = new Event("trigger");
        dispatcher.dispatchEvent(event);
        assertThat(reported, array(MacroWithNamedPayload, NamedHelloCommand, "world"));
    }

    [Test]
    public function simple_values_are_mapped_as_payloads():void {
        subject.map("trigger", Event).toCommand(MacroWithSimplePayload);
        const event:Event = new Event("trigger");
        dispatcher.dispatchEvent(event);
        assertThat(reported, array(MacroWithSimplePayload, HelloCommand, "world"));
    }
}
}

import eu.alebianco.robotlegs.utils.impl.SequenceMacro;
import eu.alebianco.robotlegs.utils.impl.SubCommandPayload;

import robotlegs.bender.bundles.mvcs.Command;

class MacroWithSimplePayload extends SequenceMacro {
    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    override public function prepare():void {
        reportingFunc(MacroWithSimplePayload);
        add(HelloCommand).withPayloads("world");
    }
}

class MacroWithNamedPayload extends SequenceMacro {
    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    override public function prepare():void {
        reportingFunc(MacroWithNamedPayload);
        var payload:SubCommandPayload = new SubCommandPayload("world", String).withName("target");
        add(NamedHelloCommand).withPayloads(payload);
    }
}

class HelloCommand extends Command {

    [Inject]
    public var who:String;

    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    [PostConstruct]
    public function init():void {
        reportingFunc(HelloCommand)
    }

    override public function execute():void {
        reportingFunc(who)
    }
}

class NamedHelloCommand extends Command {

    [Inject(name="target")]
    public var who:String;

    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    [PostConstruct]
    public function init():void {
        reportingFunc(NamedHelloCommand)
    }

    override public function execute():void {
        reportingFunc(who)
    }
}
