package scxml.invoke {
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import scxml.events.InvokeEvent;
	
	import util.ArrayUtils;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class InvokeASR extends Invoke {
		
		private var logger:ILogger = Log.getLogger("InvokeASR");
		
		public function InvokeASR() {
			ExternalInterface.addCallback("as_onResult", onResult);
			ExternalInterface.call("loadWami");
			
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			if(eventName is Array && eventName[0] == "abort") {
				abort();
				return;
			}
			logger.info("invokeasr grammar {0}", data["grammar"]);
			ExternalInterface.call("wamiApp.setGrammar", {"language" : "en-us", "grammar" : data["grammar"]});
			ExternalInterface.call("wamiApp.startRecording");
		}
		
		override protected function abort() : void {
			ExternalInterface.call("wamiApp.stopRecording");
			super.abort();
		}
		
		public function onResult(result : Object) : void {
			logger.info("you said: " + result.hyps[0].text);
			ExternalInterface.call("console.log", result.hyps[0].aggregate.kvs);
			ExternalInterface.call("wamiApp.stopRecording");
			_lastResult = result.hyps[0].text;
			dispatchEvent(new InvokeEvent(InvokeEvent.SEND_RESULT, {"lastResult" : _lastResult, "slotsFilled" : result.hyps[0].aggregate.kvs}));
		}
		protected function debug(msg : String, ...args : Array) : void {
			var argArray : Array = ArrayUtils.map(function(n : Number) : String {return "{" + n + "}"}, ArrayUtils.range(0, args.length));
			logger.debug.apply(null, [msg + " " + argArray.join(" ")].concat(args));
		}
	}
}