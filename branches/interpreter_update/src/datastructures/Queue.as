package datastructures {
	
	public class Queue {
		
		private var list : Array;
		
		public function Queue()	{
			list = []; 
		}
		
		public function enqueue(elem : *) : void {
			list.push(elem);
		}
		public function dequeue() : * {
			return list.shift();
		}
		public function isEmpty() : Boolean {
			return list.length == 0;
		}
	}
}