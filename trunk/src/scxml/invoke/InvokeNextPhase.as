package scxml.invoke {
	import datastructures.Queue;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.messaging.messages.SOAPMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import scxml.events.InvokeEvent;
	
	import util.ArrayUtils;
	
	import valueObjects.Infolet;
	import valueObjects.NextPhaseXML;
	
	import webservices.Service1;
	
	public class InvokeNextPhase extends Invoke {
	
		
		private var logger:ILogger = Log.getLogger("InvokeNextPhase");
		
		private var webservice : Service1;
		
		private var categoryResponder : CallResponder;
		private var languageResponder : CallResponder;
		private var nItemResponder : CallResponder;
		private var sourceResponder : CallResponder;
		private var newsItemsResponder : CallResponder;
		
		public function InvokeNextPhase() {
			debug("InvokeNextPhase()");
			setupResponders();
			webservice = new Service1();	
			webservice.addEventListener(FaultEvent.FAULT, function(event : FaultEvent) : void {
				Alert.show(event.fault.faultString + '\n' + event.fault.faultDetail);
			});
//			languageResponder.token = webservice.GetAvailableLanguages();
		}
		
		private function setupResponders() : void {
			categoryResponder = new CallResponder();
			categoryResponder.addEventListener(ResultEvent.RESULT, onCategoryResult);
			languageResponder = new CallResponder();
			languageResponder.addEventListener(ResultEvent.RESULT, onLanguageResult);
			newsItemsResponder = new CallResponder();
			newsItemsResponder.addEventListener(ResultEvent.RESULT, onNewItemResult);
			
		}
		
		private function onCategoryResult(event : ResultEvent) : void {
			debug("languageResult", event.result);
			debug("languageResult is string", event.result is String);
		}
		private function onLanguageResult(event : ResultEvent) : void {
			debug("categoryResult", event.result);
		}
		private function onNewItemResult(event : ResultEvent) : void {
			debug("newItemResult", event.result);
			var result : NextPhaseXML = NextPhaseXML(event.result);
			debug("infolet", result.infolets[0].title);
			debug("infolet", result.infolets[0].body);
			debug("infolet", result.infolets[0].ingress);
			debug("infolet", result.infolets[0].data);
			dispatchEvent(new InvokeEvent(InvokeEvent.SEND_RESULT, {"lastResult" : result.infolets}));
		}
		
		override public function send(eventName : Object, sendId : String = null, delay : Number = 0, data : Object = null, toQueue : Queue = null) : void {
			
			if(data.hasOwnProperty("getNewsItems"))
//				newsItemsResponder.token = webservice.GetLatestNewsItems(data.category, "SightCity_CNN", data.num);
				newsItemsResponder.token = webservice.GetLatestNewsItems("", "SightCity_CNN", 10);
			else if(data.hasOwnProperty("getCategories"))
				categoryResponder.token = webservice.GetAvailableCategories(data.language);
				
//			else if(data.hasOwnProperty("getSources")
//				sourceResponder.token = webservice.GetAvailableCategories();
		}
		
		private function onServiceResult(event : ResultEvent) : void {
			debug("result", event.result);
//			debug("result messageId", event.messageId);
//			for( var i : String in event.message.headers)
//				debug("result headers", i, event.message.headers[i]);
			
//			debug("result", GetAvailableCategoriesResult.lastResult);
		}
		
		override public function start(optionalParentExternalQueue : Queue = null, invokeId : String = null) : void {
//			get languages here, then do super.start() from onLanguageResult
			
			
			super.start(optionalParentExternalQueue, invokeId);
		}
		
		
		private function debug(msg : String, ...args : Array) : void {
			var argArray : Array = ArrayUtils.map(function(n : Number) : String {return "{" + n + "}"}, ArrayUtils.range(0, args.length));
			logger.debug.apply(null, [msg + " " + argArray.join(" ")].concat(args));
		}
		
	}
}