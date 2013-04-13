# Macrobot: Macro Commands For Robotlegs2

Macro command utility for Robotlegs which provides the ability to execute batches of commands in sequential or parallel fashion.

**NOTE** This project is a shameful port of the awesome work that [Aaronius](https://github.com/Aaronius) made for the first release of [Robotlegs](http://www.robotlegs.org/).

## Introduction

While using Robotlegs and encapsulating your business logic inside commands, you may find yourself in a situation where you wish to batch commands, instead of relying on events to trigger every step.
Macrobot simplifies this process and provide two way to group commands:

**Sequence**: The commands will be executed in order one after the other. A command will not be executed until the previous one is complete. The macro itself will not be complete until all its commands are complete.

**Parallel**: The commands will be executed as quickly as possible, with no regards on the order in which they were registered. The macro itself will not be complete until all its commands are complete.

## Usage

To create a macro command, extend on the two classes Macrobot provides: `ParallelMacro` or `SequenceMacro`.
Override the prepare() method and add sub commands by calling `addSubCommand()` specifying the command class to use.
At the appropriate time the command will be created, initiated by satisfying the injection points and then executed.
This automated process of instantiation, injection, and execution is very similar to how commands are normally prepared and executed in Robotlegs.
You could use _Guards_ and _Hooks_ as you would normally use with regular commands to control the execution workflow.
Additionally you could use the `withPayloads()` method to add some data that can be used to satisfy the injection points of the sub commands. The data provided will be available to the guards and hooks applied to the sub command as well.

Here's an example of a simple sequential macro:
```public class MyMacro extends SequenceMacro {
	override public function prepare() {
		addSubCommand(CommandA);
		addSubCommand(CommandB);
		addSubCommand(CommandC);
	}
}
```

### Asynchronous commands

While Macrobot can work with synchronous commands, it is most effective when you have to deal with asynchronous ones.
Your sub command may wait for a response from a server or for user interaction before being marked as complete.
In this case you command can subclass Macrobot's AsyncCommand and call `dispatchComplete()` when it should be marked as complete.
`dispatchComplete()` receives a single parameter which reports whether the subcommand completed successfully.

Here's an example of a simulated asynchronous sub command:
```public class MyCommandWhichHappensToBeASubcommand extends AsyncCommand     {
   	protected var timer:Timer;
   	override public function execute():void {
   		timer = new Timer(50, 1);
   		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
   		timer.start();
   	}
   	protected function timerCompleteHandler(event:TimerEvent):void {
   		timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
   		timer = null;
   		dispatchComplete(true);
   	}
   }
```

### Atomic execution

For sequential macros, when the_ atomic_ property is set to **false** (it is **true** by default) and one of the sub commands dispatches a failure (using `dispatchComplete(false)`), subsequent sub commands will not be executed and the macro itself will dispatch failure.

This behaviour does not apply to parallel commands.

## Building

In the **build** folder, make a copy of the _user.properties.eg_ file and call it _user.properties_
Edit that file to provide values specific to your system
Use the `build.xml` ant script you'll find in the **build** folder, to build the project

## Contributing

If you want to contribute to the project refer to the [CONTRIBUTING.mc](CONTRIBUTING.md) document for guidelines.

## Roadmap

* document the code
* allow functions or instances to be added as sub commands
* add test coverage