package datastructures {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Queue extends EventDispatcher {
		
		private var list : Array;
		
		public function Queue() 	{
			list = []; 
		}
		
		public function enqueue(elem : *) : void {
			if(elem == null) throw new Error("elem cannot be null");
			list.push(elem);
			dispatchEvent(new Event(Event.ADDED));
		}
		public function dequeue() : * {
			return list.shift();
		}
		public function isEmpty() : Boolean {
			return list.length == 0;
		}
		override public function toString() : String {
			return list.join(", ");
		}
	}
}