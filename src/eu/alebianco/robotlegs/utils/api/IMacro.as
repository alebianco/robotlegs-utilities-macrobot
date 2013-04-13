/**
 * Author:  Alessandro Bianco
 * Website: http://alessandrobianco.eu
 * Twitter: @alebianco
 * Created: 26/07/12 8.32
 *
 * Copyright © 2011 - 2013 Alessandro Bianco
 */
package eu.alebianco.robotlegs.utils.api {
import eu.alebianco.robotlegs.utils.dsl.MacroMapping;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

public interface IMacro extends ICommand {
    function prepare():void;

    function addSubCommand(commandClass:Class):MacroMapping;
}
}