package scxml {
	import scxml.events.SCXMLEvent;
	
	[Event(name="finalStateReached", type="scxml.events.SCXMLEvent")]
	[Event(name="start", type="scxml.events.SCXMLEvent")]
	[Event(name="stateEntered", type="scxml.events.SCXMLEvent")]
	
	[DefaultProperty("source")]
	
	public class SCXML extends Interpreter {
		
		private var compiler : Compiler;
		private var finished : Boolean = false;
		
		public function SCXML() {
			super();
		}
		override protected function onAppFinalState() : void {
			super.onAppFinalState();
			finished = true;
			dispatchEvent(new SCXMLEvent(SCXMLEvent.FINAL_STATE_REACHED));
		}
		
		public function set source(xml : XML) : void {
			if(xml is String) { //TODO: make this work.
			}
			compiler = new Compiler(this);  
			
			compiler.parse(xml);
		}
		public function start() : void {
			interpret(compiler.document);
			dispatchEvent(new SCXMLEvent(SCXMLEvent.START));
		}
		public function get currentState() : String {
			var config : Array = configuration.toList();
			return config[config.length-1]["id"];
		}
		
		public function isFinished() : Boolean {
			return finished;
		}
	}
}