package datastructures {
	import util.ArrayUtils;
	
	public class Set {
		public var list : Array;
		
		public function Set(source : Array = null)	{
			if(source) {
				var s : Set = new Set();
				for each (var item : * in source)
					s.add(item);
				list = s.toList();
			}
			else 
				list = [];
		}
		public function add(item : *) : void {
			if(list.indexOf(item) == -1) list.push(item);
		}
		public function remove(item : *) : void {
			var output : Array = [];
			for each(var i : * in list)
				if(i != item)
					output.push(i);
			list = output;
			 
			
		}
		public function member(item : *) : Boolean {
			return list.indexOf(item) != -1;
		}
		public function isEmpty() : Boolean {
			return list.length == 0;
		}
		public function toList() : Array {
			return list;
		}
		public function diff(set2 : Set) : Set {
			var output : Set = new Set();
			for each(var item : * in Array)
				if(!set2.member(item))
					output.add(item);
			return output;
		}
		public function filter(f : Function) : Set {
			return new Set(ArrayUtils.filter(f, list));
		}
		public function toString() : String {
			return list.toString();
		}
	}
}