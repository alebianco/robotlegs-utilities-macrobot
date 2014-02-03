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

public class TestXMLCommand extends Command {

    [Inject]
    public var data:XML;

    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    [PostConstruct]
    public function init():void {
        reportingFunc(TestXMLCommand);
    }

    override public function execute():void {
        reportingFunc(data.@key);
    }
}
}
