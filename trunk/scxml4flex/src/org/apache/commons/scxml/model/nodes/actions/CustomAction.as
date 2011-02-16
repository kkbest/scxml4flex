package org.apache.commons.scxml.model.nodes.actions
{
	import flash.events.ErrorEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.messaging.messages.ErrorMessage;
	
	public class CustomAction
	{
		/**
		 * The namespace this custom action belongs to.
		 */
		private var namespaceURI:String = null;
		
		/**
		 * The local name of the custom action.
		 */
		private var localName:String;
		
		/**
		 * The implementation of this custom action.
		 */
		private var actionClass:Class;
		
		public function CustomAction(nsURL:String,lName:String,aObject:Object)
		{
			if(nsURL==null||nsURL=="") throw new ErrorEvent("Bad CustomAction Namespace URI Parameter");
			if(lName==null||lName=="") throw new ErrorEvent("Bad CustomAction localName Parameter");
			if(aObject==null) throw new ErrorEvent("Bad CustomAction Class Object Parameter");
			
			namespaceURI=nsURL;
			localName=lName;
			actionClass=Class(getDefinitionByName(getQualifiedClassName(aObject)));
		}
		
		/**
		 * Get this custom action's implementation.
		 *
		 * @return Returns the action class.
		 */
		public function getActionClass():Class {
			return actionClass;
		}
		
		/**
		 * Get the local name for this custom action.
		 *
		 * @return Returns the local name.
		 */
		public function getLocalName():String {
			return localName;
		}
		
		/**
		 * Get the namespace URI for this custom action.
		 *
		 * @return Returns the namespace URI.
		 */
		public function getNamespaceURI():String {
			return namespaceURI;
		}
	}
}