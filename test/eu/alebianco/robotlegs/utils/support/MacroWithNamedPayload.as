/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 03/02/2014 10:51
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.support {
import eu.alebianco.robotlegs.utils.impl.SequenceMacro;
import eu.alebianco.robotlegs.utils.impl.SubCommandPayload;

public class MacroWithNamedPayload extends SequenceMacro {
    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    override public function prepare():void {
        reportingFunc(MacroWithNamedPayload);
        var payload:SubCommandPayload = new SubCommandPayload("world", String).withName("target");
        add(NamedHelloCommand).withPayloads(payload);
    }
}
}
