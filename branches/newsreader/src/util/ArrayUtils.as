package util {
	public class ArrayUtils	{
		
		public static function member(elem : *, array : Array) : Boolean {
			for each(var item : * in array)
				if(item == elem) return true;
			return false;
		}
		
		public static function mapProperty(array : Array, prop : String) : Array {
			return array.map(function(item:*, index:int, a:Array) : String {
					return item[prop]
				});
		}
		
		public static function all(a : Array) : Boolean {
			function f(item:*, index:int, array:Array) : Boolean {return Boolean(item)} 
			return a.every(f);
		}
		public static function any(a : Array) : Boolean {
			function f(item:*, index:int, array:Array) : Boolean {return Boolean(item)}
			return a.some(f);
		}
		public static function map(func : Function, a : Array) : Array {
			function f(item:*, index:int, array:Array) : * {return func(item)}
			return a.map(f);
		}
		public static function filter(func : Function, a : Array) : Array {
			function f(item:*, index:int, array:Array) : Boolean {return func(item)}
			return a.filter(f);
		}
		public static function range(from : int, to : int) : Array {
			var output : Array = [];
			for(var i : int = from; i < to; i++)
				output.push(i);
			return output;
		}
	}
}