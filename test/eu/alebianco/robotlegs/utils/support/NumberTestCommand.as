/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 03/02/2014 10:52
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.support {
import robotlegs.bender.bundles.mvcs.Command;

public class NumberTestCommand extends Command {

    [Inject]
    public var number:Number;

    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    [PostConstruct]
    public function init():void {
        reportingFunc(NumberTestCommand);
    }

    override public function execute():void {
        reportingFunc(number);
    }
}
}
