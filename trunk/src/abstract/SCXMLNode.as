package abstract {
	import flash.errors.IllegalOperationError;
	
	public class SCXMLNode {
		protected var optionalProperties : Array;
		
		public function setProperties(node : XML) : void {
			if(!optionalProperties) throw new IllegalOperationError("optionalProperties is empty, this property must be overwritten.");
			for each(var p : String in optionalProperties)
				if(node.hasOwnProperty("@" + p))
					this[p] = String(node.@[p]);
		}
		
	}
}