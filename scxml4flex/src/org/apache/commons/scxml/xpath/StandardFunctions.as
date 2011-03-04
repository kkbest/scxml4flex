package org.apache.commons.scxml.xpath
{
	import mx.utils.ObjectUtil;
	
	dynamic public class StandardFunctions
	{
		public function StandardFunctions()
		{
			this["compare"]=strCompare;
			this["codepoint-equal"]=codepointEqual;
			this["contains"]=strContains;
			this["starts-with"] = startsWith;
			this["ends-with"] = endsWith;
			this["substring_before"]=substringBefore;
			this["substring_after"]=substringAfter;
		}
		
		
		
		 /******************************************************** 
		  *                   String Functions                   *
		  ********************************************************/ 
		public function strCompare(a:String,b:String):int{
			return ObjectUtil.stringCompare(a,b,false);
		}
		public function codepointEqual(a:String,b:String):Boolean{
			if(a==null||b==null) return false;
			else return a==b?true:false;
		}
		public function strContains(a:String,b:String):Boolean{
			return a.indexOf(b)>-1;
		}
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
		public function substringBefore(a:String,b:String):String{
			var p:int=a.indexOf(b);
			if(p>-1){
				return a.substring(0,p);
			}else return "";
		}
		public function substringAfter(a:String,b:String):String{
			var p:int=a.indexOf(b);
			if(p>-1){
				if(p+b.length<a.length){
					return a.substring(p+b.length,a.length);
				}else return "";
			}else return "";
		}
	}
}