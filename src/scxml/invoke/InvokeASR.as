package scxml.invoke {
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import scxml.events.InvokeEvent;

	public class InvokeASR extends Invoke {
		
		
		public function InvokeASR() {
			ExternalInterface.addCallback("as_onResult", onResult);
			ExternalInterface.call("loadWami");
			
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			ExternalInterface.call("wamiApp.setGrammar", {"language" : "en-us", "grammar" : data["grammar"]});
			ExternalInterface.call("wamiApp.startRecording");
		}
		
		public function onResult(result : Object) : void {
			trace("you said:", result.hyps[0].text);
			ExternalInterface.call("wamiApp.stopRecording");
			_lastResult = result.hyps[0].text;
			dispatchEvent(new InvokeEvent(InvokeEvent.SEND_RESULT, {"lastResult" : _lastResult}));
		}

	}
}