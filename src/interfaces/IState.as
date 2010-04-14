package interfaces {
	import scxml.nodes.Initial;
	
	public interface IState {
		function get n() : Number;
		function get parent() : IState;
		function get id() : String;
		function get invokeid() : String;
		
		function get onexit() : Array;
		function get onentry() : Array;
		function addOnEntry(e : IExecutable) : void;
		function addOnExit(e : IExecutable) : void;
		
		function getChildStates() : Array;
		
		function get isAtomicState() : Boolean;
		function get isCompoundState() : Boolean;
		function get transition() : Array;
		function get history() : Array;
		function get invoke() : Array;
		function get initial() : Initial;
		function get viewstate() : String;
		
//		function get initExec() : IExecutable;
		
	}
}