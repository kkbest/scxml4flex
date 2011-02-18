package org.apache.commons.scxml.datastructures
{
	public class CustomActionClassMap
	{
		private var elementName:String = null;
		private var classPath:String = null;
		
		public function CustomActionClassMap(en:String,cp:String)
		{
			elementName=en;
			classPath=cp;
		}
		
		public function getElementName():String{
			return elementName;
		}
		
		public function getClassPath():String{
			return classPath;
		}
	}
}