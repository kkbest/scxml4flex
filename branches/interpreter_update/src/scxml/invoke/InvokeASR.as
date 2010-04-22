package scxml.invoke {
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import scxml.events.InvokeEvent;

	public class InvokeASR extends Invoke {
		
		private var _lastResult : String = "";
		
		public function InvokeASR() {
			ExternalInterface.addCallback("as_onResult", onResult);
			ExternalInterface.call("loadWami");
			
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null) : void {
			trace("asr send", data["grammar"]);
			ExternalInterface.call("wamiApp.setGrammar", {"language" : "en-us", "grammar" : data["grammar"]});
			ExternalInterface.call("wamiApp.startRecording");
		}
		
		public function onResult(result : Object) : void {
			trace("you said:", result.hyps[0].text);
			_lastResult = result.hyps[0].text;
			dispatchEvent(new InvokeEvent(InvokeEvent.RESULT, {"lastResult" : _lastResult}));
		}

		public function get lastResult():String
		{
			trace("you got last result", _lastResult);
			return _lastResult;
		}
		
		
	}
}