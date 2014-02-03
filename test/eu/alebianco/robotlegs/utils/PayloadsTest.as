/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 13/04/13 11.46
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils {
import eu.alebianco.robotlegs.utils.support.HelloCommand;
import eu.alebianco.robotlegs.utils.support.MacroWithNamedPayload;
import eu.alebianco.robotlegs.utils.support.MacroWithNumberPayload;
import eu.alebianco.robotlegs.utils.support.MacroWithSimplePayload;
import eu.alebianco.robotlegs.utils.support.NamedHelloCommand;
import eu.alebianco.robotlegs.utils.support.NumberTestCommand;

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

	/**
	 * assurance that Proxy, Number, XML, XMLList, Vector instances are managed correctly
	 * for more info see: https://github.com/robotlegs/swiftsuspenders/blob/master/src/org/swiftsuspenders/reflection/ReflectorBase.as
	 */

	[Test]
	public function number_values_are_mapped_as_payloads():void {
		subject.map("trigger", Event).toCommand(MacroWithNumberPayload);
		const event:Event = new Event("trigger");
		dispatcher.dispatchEvent(event);
		assertThat(reported, array(MacroWithNumberPayload, NumberTestCommand, Math.PI));
	}
}
}