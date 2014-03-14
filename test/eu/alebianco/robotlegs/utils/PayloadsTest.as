/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 13/04/13 11.46
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils {
import eu.alebianco.robotlegs.utils.support.MacroWithXMLPayload;
import eu.alebianco.robotlegs.utils.support.TestIntCommand;
import eu.alebianco.robotlegs.utils.support.TestStringCommand;
import eu.alebianco.robotlegs.utils.support.MacroWithNamedPayload;
import eu.alebianco.robotlegs.utils.support.MacroWithNumberPayload;
import eu.alebianco.robotlegs.utils.support.MacroWithPseudoNullPayload;
import eu.alebianco.robotlegs.utils.support.MacroWithSimplePayload;
import eu.alebianco.robotlegs.utils.support.TestNameStringCommand;
import eu.alebianco.robotlegs.utils.support.TestNumberCommand;
import eu.alebianco.robotlegs.utils.support.TestXMLCommand;
import eu.alebianco.robotlegs.utils.support.TestXMLListCommand;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;

import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
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
        assertThat(reported, array(MacroWithNamedPayload, TestNameStringCommand, "world"));
    }

    [Test]
    public function simple_values_are_mapped_as_payloads():void {
        subject.map("trigger", Event).toCommand(MacroWithSimplePayload);
        const event:Event = new Event("trigger");
        dispatcher.dispatchEvent(event);
        assertThat(reported, array(MacroWithSimplePayload, TestStringCommand, "world"));
    }

	[Test]
	public function number_values_are_mapped_as_payloads():void {
		subject.map("trigger", Event).toCommand(MacroWithNumberPayload);
		const event:Event = new Event("trigger");
		dispatcher.dispatchEvent(event);
		assertThat(reported, array(MacroWithNumberPayload, TestNumberCommand, Math.PI));
	}

	[Test]
	public function pseudo_null_values_are_mapped_as_payloads():void {
		subject.map("trigger", Event).toCommand(MacroWithPseudoNullPayload);
		const event:Event = new Event("trigger");
		dispatcher.dispatchEvent(event);
		assertThat(reported, array(MacroWithPseudoNullPayload, TestStringCommand, "", TestIntCommand, 0, TestNumberCommand, NaN));
	}

	[Test]
	public function xml_values_as_payloads():void {
		subject.map("trigger", Event).toCommand(MacroWithXMLPayload);
		const event:Event = new Event("trigger");
		dispatcher.dispatchEvent(event);
		assertThat(reported, array(MacroWithXMLPayload, TestXMLCommand, "color", TestXMLListCommand, 7));
	}
}
}