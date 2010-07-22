package scxml.error {
	public class SCXMLValidationError extends Error {
		public function SCXMLValidationError(msg : String, id : int = 0) {
			super(msg, id);
		}

	}
}