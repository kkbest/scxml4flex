package org.apache.commons.scxml.model.error {
	public class SCXMLValidationError extends Error {
		public function SCXMLValidationError(msg : String, id : int = 0) {
			super(msg, id);
		}

	}
}