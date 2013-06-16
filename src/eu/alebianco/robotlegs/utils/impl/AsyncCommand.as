/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.impl {

import eu.alebianco.robotlegs.utils.api.IAsyncCommand;

import robotlegs.bender.framework.api.IContext;

public class AsyncCommand implements IAsyncCommand {
    protected var listeners:Array;

    [Inject]
    public var context:IContext;

    public function registerCompleteCallback(listener:Function):void {
        listeners ||= [];
        listeners.unshift(listener);
    }

    public function execute():void {
        context.detain(this);
    }

    protected function dispatchComplete(success:Boolean):void {
        context.release(this);
        for each (var listener:Function in listeners) {
            listener(success);
        }
    }
}
}
