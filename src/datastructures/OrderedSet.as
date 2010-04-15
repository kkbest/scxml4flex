package datastructures {
	import mx.utils.ArrayUtil;
	
	import util.ArrayUtils;

	public dynamic class OrderedSet extends Array {
		
//		private var a : Array;
		
		public function OrderedSet(start : Array = null) {
			super();
			if(!start) 
				start = [];
			for each(var elem : * in start)
				push(elem);
		}
		
		public function member(elem : *) : Boolean {
			return ArrayUtils.member(elem, this);
		}
		public function remove(elem : *) : void {
			var n : int = this.indexOf(elem);
			this.splice(n, 1);
			
		}
		public function isEmpty() : Boolean {
			return length == 0;
		}
		public function add(elem : *) : void {
			if(!elem) throw new Error("null elem added to OrderedSet");
			if(!member(elem)) 
				push(elem);
		}
		public function clear() : void {
//			a = [];
			splice(0);
		}
		
		
//		override public function filter(f : Function) : OrderedSet {
//			return new OrderedSet(ArrayUtils.filter(f, this));
//		}
		
//		public function toList() : Array {
//			return [].concat(this);
//		}
	}
}