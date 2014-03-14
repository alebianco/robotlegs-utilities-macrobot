/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package suites {
import eu.alebianco.robotlegs.utils.AsyncCallbackTest;
import eu.alebianco.robotlegs.utils.PayloadsTest;

[RunWith("org.flexunit.runners.Suite")]
[Suite]
public class FullSuite {
    public var payloads:PayloadsTest;
    public var callbacks:AsyncCallbackTest;
}
}
