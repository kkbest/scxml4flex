package flexUnitTests {
	import flash.events.Event;
	import flash.utils.Timer;
	
	import flexunit.framework.Assert;
	
	import scxml.SCXML;
	import scxml.events.SCXMLEvent;

	public class InterpreterTester {		
		
		private var interpreter : SCXML;
		
		[Embed(source="../../unittest_xml/colors.xml", mimeType="text/xml")]
		protected const HistoryXML : Class;
		
		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
//		private function onDone(event : Event) : void {
//			Assert.assertTrue(!interpreter.isFinished());
//		}
		
		[Test]
		public function testHistory() : void {
			interpreter = new SCXML();
//			interpreter.addEventListener(SCXMLEvent.FINAL_STATE_REACHED, onDone);
			interpreter.source = XML(new HistoryXML());
			interpreter.start();
			
			Assert.assertTrue(interpreter.isFinished());
//			interpreter.send("e1");
//			interpreter.send("pause");
//			interpreter.send("resume");
//			interpreter.send("terminate");
			
			
			
		}
	}
}