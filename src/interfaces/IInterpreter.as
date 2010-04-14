package interfaces {
	public interface IInterpreter {
		
		function send(eventName : Array, sendId : String = null, delay : Number = 0, data : Object = null) : void;
		function cancelEvent(sendId : String) : void;
		
	}
}