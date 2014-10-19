package eu.alebianco.robotlegs.utils {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.hamcrest.assertThat;

	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	import org.hamcrest.collection.array;

	public class InstanceTest {

		private var injector : IInjector;
		private var mappings : Vector.<ICommandMapping>;
		private var dispatcher : IEventDispatcher;
		private var subject : IEventCommandMap;
		private var reported : Array;

		private function reportingFunction(item : Object) : void {
			reported.push(item);
		}

		[Before]
		public function before() : void {
			reported = [];
			injector = new RobotlegsInjector();
			const context : IContext = new Context();
			injector = context.injector;
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			dispatcher = new EventDispatcher();
			subject = new EventCommandMap(context, dispatcher);
		}

		[After]
		public function after() : void {
			injector = null;
		}

		[Test]
		public function payload_instances_are_mapped() : void {
			subject.map("trigger", Event).toCommand(TestSequence);
			const event : Event = new Event("trigger");
			dispatcher.dispatchEvent(event);
			assertThat(reported, array("hello", "test", "test", "good buy"));
		}

	}
}
import eu.alebianco.robotlegs.utils.impl.ParallelMacro;
import eu.alebianco.robotlegs.utils.impl.SequenceMacro;

import robotlegs.bender.bundles.mvcs.Command;

class TestSequence extends SequenceMacro {

	override public function prepare() : void {
		add(ReportString).withPayloads("hello");
		var inlineParallelMacro : InlineParallelMacro = new InlineParallelMacro();
		inlineParallelMacro.add(ReportString).withPayloads("test");
		inlineParallelMacro.add(ReportString).withPayloads("test");
		addInstance(inlineParallelMacro);
		add(ReportString).withPayloads("good buy");
	}
}

class ReportString extends Command {

	[Inject(name="reportingFunction")]
	public var reportingFunc : Function;

	[Inject]
	public var string : String;

	override public function execute() : void {
		reportingFunc(string);
	}
}

class InlineParallelMacro extends ParallelMacro {

	override public function prepare() : void {
		//suppress throwing error
	}

}
