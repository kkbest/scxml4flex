package scxml.invoke {
	
	import com.acapela.vaas.BasicVaas;
	
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import scxml.events.InvokeEvent;
	
	import util.ArrayUtils;
	
	public class InvokeTTS extends Invoke {

		private var _invokeid : String;
		private var _type : String;
		
		private var staticMsgs : SharedObject;
		
		private var vaas : BasicVaas;
		private var toSay : String;
		private var _abort : Boolean = false;
		private var soundPlaying : SoundChannel;
		
		private var logger:ILogger = Log.getLogger("InvokeTTS");
		
		private var _time : Number;
		
		public function InvokeTTS()	{
			setupVaas();
		}
		
		private function setupVaas() : void {
			vaas = new BasicVaas(); 
			vaas.accountLogin = "EVAL_VAAS";
			vaas.applicationLogin = "EVAL_805428";
			vaas.password = "dhk3t189";
			
			vaas.addEventListener(BasicVaas.MESSAGE_AVAILABLE, onVoice);
			vaas.addEventListener(BasicVaas.ERROR, onVaasError);
			
			staticMsgs = SharedObject.getLocal("vaas");
			
		}
		
		private function onVoice(event:Event) : void {
			if(_abort) {
				_abort = false;
				return;
			}
			logger.info("sound loaded in (ms):" + ((Date.parse(new Date().toString()) + new Date().milliseconds) - _time)); 
			var target : BasicVaas = BasicVaas(event.target);
			_lastResult = target.requestedSound;
			soundPlaying = target.requestedSound.play(); 
			soundPlaying.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			staticMsgs.setProperty(toSay, vaas.requestedId);
			dispatchEvent(new InvokeEvent(InvokeEvent.LOADED));
		}
		
		private function onPlaybackComplete(event : Event) : void {
			soundPlaying.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			dispatchEvent(new InvokeEvent(InvokeEvent.SEND_RESULT, {"lastResult" : _lastResult}));
			soundPlaying = null;
		}
		
		private function onVaasError(event:Event) : void {
			logger.error(BasicVaas(event.target).lastError);
		}
		
		override protected function abort() : void {
			debug("abort");
			if(!soundPlaying) return;
			_abort = true;
			soundPlaying.stop();
			soundPlaying.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			soundPlaying = null;
			super.abort();
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			if(eventName is Array && eventName[0] == "abort") {
				abort();
				return;
			}
			debug("tts say", data);
			for(var i : String in data)
				debug("key:", i, "value:", data[i]);
			if(!data["say"] || data["say"] == "") throw new Error("The say variable was empty");
			toSay = data["say"];
			_time = Date.parse(new Date().toString()) + new Date().milliseconds;
			if(staticMsgs.data[toSay] != null) {
				logger.info("found cached sound: " + toSay);
				vaas.retrieveMessage(staticMsgs.data[toSay]);
			}
			else {
				logger.warn("no cached sound: " + toSay);
				vaas.generateMessage("peter22k", data["say"]);
			}
			
		}
		protected function debug(msg : String, ...args : Array) : void {
			var argArray : Array = ArrayUtils.map(function(n : Number) : String {return "{" + n + "}"}, ArrayUtils.range(0, args.length));
			logger.debug.apply(null, [msg + " " + argArray.join(" ")].concat(args));
		}	
	}
}