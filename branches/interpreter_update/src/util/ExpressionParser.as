package util {
	
	/**
	 * Defined a really small subset of ecmascript, 
	 * some sort of json query notation without being JSONQuery.
	 * TODO: either make the datamodel xml based or implement JSONQuery
	 * for real. Negative indexes in array access notation is supported.
	 */
	
	public class ExpressionParser {
		
		private static function parse(expr : String) : Array {
			expr = expr.replace(new RegExp("'|\"", "g") , "");
			expr = expr.replace(/\[(.+?)\]/g, "\.$1");
			
			return expr.split(".");
		}
		
		public static function access(target : Object, expr : String) : * {
			var pathArray : Array = parse(expr);
			var isDigit : RegExp = /\d/;
			
			for each(var item : String in pathArray)
				if(isDigit.test(item)) {
					var n : int = Number(item);
					if(n < 0) 
						target = target.slice(n);
					else 
						target = target[n];
				}
				else
					target = target[item];
			return target;
		}
	}
}