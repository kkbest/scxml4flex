package interfaces {
	public interface IInterpreter {
		
		function send(eventName : String, sendId : String = null, data : Object = null, delay : Number = 0) : void;
		function cancelEvent(sendId : String) : void;
		
	}
}