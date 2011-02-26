package org.apache.commons.scxml.xpath
{
	dynamic public class StandardFunctions
	{
		public function StandardFunctions()
		{
			this["starts_with"] = startsWith;
		}
		
		//corresponding to function "starts-with" in XPath 2.0 specification
		public function startsWith(one:String,two:String):Boolean{
			if(one.substr(0,two.length)==two)
				return true;
			else return false;
		}
	}
}