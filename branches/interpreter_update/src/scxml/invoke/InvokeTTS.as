package scxml.invoke {
	
	import com.acapela.vaas.BasicVaas;
	
	import datastructures.Queue;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	
	import scxml.events.InvokeEvent;
	
	
	
	public class InvokeTTS extends Invoke {

		private var _invokeid : String;
		private var _type : String;
		
		private var staticMsgs : SharedObject;
		
		private var vaas : BasicVaas;
		private var toSay : String;
		
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
			var target : BasicVaas = BasicVaas(event.target);
			_lastResult = target.requestedSound;
			target.requestedSound.play().addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			staticMsgs.setProperty(toSay, vaas.requestedId);
		}
		
		private function onPlaybackComplete(event : Event) : void {
			SoundChannel(event.currentTarget).removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			dispatchEvent(new InvokeEvent(InvokeEvent.SEND_RESULT, {"lastResult" : _lastResult}));
		}
		
		private function onVaasError(event:Event) : void {
			trace("an error occured : " +  BasicVaas(event.target).lastError);
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			trace("tts send");
			for(var i : String in data)
				trace(i, data[i]);
			toSay = data["say"];
			if(staticMsgs.data[toSay] != null)
				vaas.retrieveMessage(staticMsgs.data[toSay]);
			else
				vaas.generateMessage("peter22k", data["say"]);
			
		}
		
	}
}