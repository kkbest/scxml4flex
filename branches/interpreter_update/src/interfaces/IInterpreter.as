package interfaces {
	public interface IInterpreter {
		
		function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null) : void;
		function raiseFunction(eventName : Array) : void;
		
		function cancelEvent(sendId : String) : void;
		
	}
}