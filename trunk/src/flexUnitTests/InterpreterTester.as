package flexUnitTests {
	import flexunit.framework.Assert;
	
	import scxml.SCXML;

	public class InterpreterTester {		
		
		[Embed(source="../../unittest_xml/history.xml", mimeType="text/xml")]
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
		
		[Test]
		public function testHistory() : void {
			var interpreter : SCXML = new SCXML();
			interpreter.source = XML(new HistoryXML());
			interpreter.send("e1");
			interpreter.send("pause");
			interpreter.send("resume");
			interpreter.send("terminate");
			Assert.assertTrue(interpreter.isFinished());
			
			
			
		}
	}
}