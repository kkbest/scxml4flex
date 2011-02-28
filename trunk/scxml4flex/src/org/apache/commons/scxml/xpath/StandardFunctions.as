package org.apache.commons.scxml.xpath
{
	dynamic public class StandardFunctions
	{
		public function StandardFunctions()
		{
			this["starts_with"] = startsWith;
			this["ends_with"] = endsWith;
		}
		
		
		
		 /******************************************************** 
		  *                   String Functions                   *
		  ********************************************************/ 
		public function startsWith(one:String,two:String):Boolean{
			if(one.substr(0,two.length)==two)
				return true;
			else return false;
		}
		public function endsWith(a:String,b:String):Boolean{
			if(a.length<b.length) return false;
			else{
				if(a.substr(a.length-b.length,b.length)==b) return true;
				else return false;
			}
		}
	}
}