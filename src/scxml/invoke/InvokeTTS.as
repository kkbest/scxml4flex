package scxml.invoke {
	
	import com.acapela.vaas.BasicVaas;
	import flash.events.Event;
	
	
	
	public class InvokeTTS extends Invoke {

		private var _invokeid : String;
		private var _type : String;
		
		private var vaas : BasicVaas;
		
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
			
		}
		
		private function onVoice(event:Event) : void {
			var target : BasicVaas = BasicVaas(event.target);
			target.requestedSound.play();
		}
		
		private function onVaasError(event:Event) : void {
			trace("an error occured : " +  BasicVaas(event.target).lastError);
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null) : void {
			vaas.generateMessage("peter22k", data["say"]);
		}
		
	}
}