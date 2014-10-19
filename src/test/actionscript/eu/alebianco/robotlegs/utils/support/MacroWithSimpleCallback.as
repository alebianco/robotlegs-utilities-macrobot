/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 13/03/2014 14:42
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.support {
import eu.alebianco.robotlegs.utils.impl.SequenceMacro;

import flash.events.Event;

import flash.events.IEventDispatcher;

public class MacroWithSimpleCallback extends SequenceMacro {

    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    [Inject]
    public var dispatcher:IEventDispatcher;

    override public function prepare():void {
        registerCompleteCallback(onSimpleComplete);

        reportingFunc(MacroWithSimpleCallback);
        add(SimpleAsyncCommand);
    }

    private function onSimpleComplete():void {
        dispatcher.dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
