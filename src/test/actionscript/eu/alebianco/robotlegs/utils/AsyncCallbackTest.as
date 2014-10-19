/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 13/03/2014 14:40
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils {
import eu.alebianco.robotlegs.utils.support.MacroWithSimpleCallback;
import eu.alebianco.robotlegs.utils.support.SimpleAsyncCommand;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.flexunit.Assert;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;

import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.Context;
import robotlegs.bender.framework.impl.RobotlegsInjector;

public class AsyncCallbackTest {

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
        dispatcher = new EventDispatcher();
        const context:IContext = new Context();
        injector = new RobotlegsInjector();
        injector = context.injector;
        injector.map(Function, "reportingFunction").toValue(reportingFunction);
        injector.map(IEventDispatcher).toValue(dispatcher);
        subject = new EventCommandMap(context, dispatcher);
    }

    [After]
    public function after():void {
        injector = null;
    }

    [Test(async)]
    public function payload_instances_are_mapped():void {
        subject.map("trigger", Event).toCommand(MacroWithSimpleCallback);

        const handler:Function = Async.asyncHandler(this, handleComplete, 1000, null, handleTimeout);
        dispatcher.addEventListener(Event.COMPLETE, handler, false, 0, true);

        const event:Event = new Event("trigger");
        dispatcher.dispatchEvent(event);
    }

    private function handleComplete(event:Event, passThroughData:Object):void {
        assertThat(reported, array(MacroWithSimpleCallback, SimpleAsyncCommand));
    }

    private function handleTimeout(passThroughData:Object):void {
        Assert.fail("Pending event timed out");
    }
}
}