/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 13/03/2014 14:45
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.support {
import eu.alebianco.robotlegs.utils.impl.AsyncCommand;

import flash.utils.setTimeout;

public class SimpleAsyncCommand extends AsyncCommand {

    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    [PostConstruct]
    public function init():void {
        reportingFunc(SimpleAsyncCommand);
    }

    override public function execute():void {
        setTimeout(dispatchComplete, 100, true);
    }
}
}
