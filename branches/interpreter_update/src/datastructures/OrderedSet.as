package datastructures {
	import mx.utils.ArrayUtil;
	
	import util.ArrayUtils;

	public class OrderedSet {
		
		private var a : Array;
		
		public function OrderedSet(start : Array = null) {
			if(!start) 
				start = [];
			a = [].concat(start);
		}
		
		public function member(elem : *) : Boolean {
			return ArrayUtils.member(elem, a);
		}
		public function deleteItem(elem : *) : void {
			a = ArrayUtils.filter(function(item : *) : Boolean {
				return item != elem;
			}, a);
		}
		public function isEmpty() : Boolean {
			return a.length == 0;
		}
		public function add(elem : *) : void {
			if(!member(elem)) 
				a.push(elem);
		}
		public function clear() : void {
			a = [];
		}
		
		public function toString():String {
			return a.toString();
		}
		
	}
}