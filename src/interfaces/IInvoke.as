package interfaces {
	import datastructures.Queue;

	public interface IInvoke {
		function get invokeid() : String;
		function set invokeid(id : String) : void;
		
		function get type() : String;
		function set type(str : String) : void;
		
		function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void;
		function send(msg : String) : void;
	}
}