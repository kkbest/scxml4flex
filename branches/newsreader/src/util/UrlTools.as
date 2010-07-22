package util {
	public class UrlTools {
		public static var ident_mapping : Object = {'%24': '$', '@': '%40', '%40': '@', '%2B': '+', '&': '%26', '+': '%2B', '%26': '&', ',': '%2C', '%3F': '?',
		 '%3D': '=', '%3B': ';', '%3A': ':', '%2C': ',', ';': '%3B', ':': '%3A', '=': '%3D', '?': '%3F', '$': '%24'};
		
		public static function escape(str : String) : String {
			var output : String = "";
			for each(var char : String in str.split("")) {
				if(ident_mapping[char])
					output += ident_mapping[char];
				else
					output += char;
			}
			return output;
		}

	}
}