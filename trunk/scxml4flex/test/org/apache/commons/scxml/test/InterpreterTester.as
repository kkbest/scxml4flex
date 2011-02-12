package org.apache.commons.scxml.test {
	import flexunit.framework.Assert;

	import org.apache.commons.scxml.model.SCXML;
	import org.apache.commons.scxml.model.events.SCXMLEvent;

	import org.flexunit.async.Async;
	

	public class InterpreterTester {		
		
		private var interpreter : SCXML;
		private var optionalCond : Function;
		
		[Embed(source="../unittest_xml/history.xml")]
		protected const HistoryXML : Class;
		[Embed(source="../unittest_xml/factorial.xml")]
		protected const FacXML : Class;
		[Embed(source="../unittest_xml/colors.xml")]
		protected const ColorXML : Class;
		[Embed(source="../unittest_xml/parallel.xml")]
		protected const ParallelXML : Class;
		[Embed(source="../unittest_xml/all_configs.xml")]
		protected const ConfigXML : Class;
		[Embed(source="../unittest_xml/issue_626.xml")]
		protected const Issue626XML : Class;
		[Embed(source="../unittest_xml/twolock_door.xml")]
		protected const TwolockXML : Class;
		
		[Before(async)]
		public function setUp():void
		{
			interpreter = new SCXML();
			
		}
		
		[After]
		public function tearDown():void
		{
			interpreter = null;
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		private function setCallback(interpreter : SCXML) : void {
			var asyncHandler:Function = Async.asyncHandler( this, onDone, 500, null, onTimeout );
			interpreter.addEventListener(SCXMLEvent.FINAL_STATE_REACHED, asyncHandler, false, 0, true );
		} 
		
		private function onDone(event:SCXMLEvent, passThroughData:Object) : void {
			if(optionalCond != null) {
				Assert.assertTrue(optionalCond());
				optionalCond = null;
			}
		}
		
		protected function onTimeout( passThroughData:Object ):void {
			Assert.fail( "Timeout reached before event");
		}
		
		[Test(async)] 
		public function testHistory() : void {
			setCallback(interpreter);
			interpreter.source = XML(HistoryXML.data);
			interpreter.start();
			interpreter.send("e1");
			interpreter.send("pause");
			interpreter.send("resume");
			interpreter.send("terminate");
		}
		
		[Test(async)]
		public function testFac() : void {
			setCallback(interpreter);
			interpreter.source = XML(FacXML.data);
			optionalCond = function() : Boolean {
				return interpreter.dataModel["fac"] == 720;
			};
			interpreter.start();
			
		}
		[Test(async)]
		public function testColor() : void {
			interpreter.source = XML(ColorXML.data);
			interpreter.start();
		}
		[Test(async)]
		public function testParallel() : void {
			interpreter.source = XML(ParallelXML.data);
			interpreter.start();
		}

		[Test(async)]
		public function testConfig() : void {
			interpreter.source = XML(ConfigXML.data);
			interpreter.start();
			interpreter.send("a");
			interpreter.send("b");
			interpreter.send("c");
			interpreter.send("d");
			interpreter.send("e");
			interpreter.send("f");
			interpreter.send("g");
			interpreter.send("h");
		}
		
		[Test(async)]
		public function testIssue626() : void {
			interpreter.source = XML(Issue626XML.data);
			interpreter.start();
			optionalCond = function() : Boolean {
				trace("issue626", interpreter.dataModel["x"]);
				return interpreter.dataModel["x"] == 584346861767418750;
			};
			
		}
		[Test(async)]
		public function testTwolock() : void {
			interpreter.source = XML(TwolockXML.data);
			interpreter.start();
			
		}
		
	}
}