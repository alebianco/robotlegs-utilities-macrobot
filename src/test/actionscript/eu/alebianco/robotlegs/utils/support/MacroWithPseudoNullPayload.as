/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 03/02/2014 10:56
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.support {
import eu.alebianco.robotlegs.utils.impl.SequenceMacro;

public class MacroWithPseudoNullPayload extends SequenceMacro {
    [Inject(name="reportingFunction")]
    public var reportingFunc:Function;

    override public function prepare():void {
        reportingFunc(MacroWithPseudoNullPayload);
        add(TestStringCommand).withPayloads("");
        add(TestIntCommand).withPayloads(0);
        add(TestNumberCommand).withPayloads(NaN);
    }
}
}
