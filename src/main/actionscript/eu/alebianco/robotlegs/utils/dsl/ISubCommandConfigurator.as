/**
 * Author:  alessandro.bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 12/06/2013 11:24
 *
 * Copyright © 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.dsl {
public interface ISubCommandConfigurator {

    function withGuards(...guards):ISubCommandConfigurator;

    function withHooks(...hooks):ISubCommandConfigurator;

    function withPayloads(...payloads):ISubCommandConfigurator;

    function withExecuteMethod(name:String):ISubCommandConfigurator;
}
}
