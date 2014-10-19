package eu.alebianco.robotlegs.utils.impl {
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	import robotlegs.bender.framework.api.IInjector;

	public class SubCommandInstanceMapping extends SubCommandMapping {

		private var _instance : ICommand;

		public function SubCommandInstanceMapping(instance:ICommand) {
			_instance = instance;
			super(Object(instance).constructor);
		}

		override public function getOrCreateCommandInstance(injector : IInjector) : ICommand {
			injector.injectInto(_instance);
			return _instance;
		}
	}
}
