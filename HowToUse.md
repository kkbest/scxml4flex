#Tell us how to start us SCXML4Flex

# Requirements #
SCXML4Flex support Flex 3 or greater

# Installation #

To install SCXML4Flex, get a fresh copy of the source from the repository or download .swc compiled package. Anyway, you'll then have to add the library to the classpath of you project.

# Use #

First, you should have a SCXML document, then you use SCXML4Flex to parse this document, suppose you have a document like this.
```
<scxml initial="s1" >
	<datamodel>
		<data id="x" expr="1"/>
	</datamodel>  
	<state id="s1">
		<onentry>
			<script>
				x = x + 5;
			</script>
		</onentry>
        <transition cond="x &gt; 1" target="print">
        	<log label="Transition Log:" expr="x"/>
		</transition>
    </state>
    <state id="print">
    	<onexit>
    		<log label="Result" expr="x"/>
    	</onexit>
    	<transition event="result" target="result" />	
    </state>
   <final id="result"/>
</scxml>
```
A demo Flex .mxml file is like this.
```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application 
	xmlns:mx="http://www.adobe.com/2006/mxml"
	xmlns:adobe="http://www.adobe.com/2009/flexUnitUIRunner"
	xmlns:s="library://ns.adobe.com/flex/spark" 
	minWidth="955" minHeight="600"
	creationComplete="initPage()" layout="absolute"
	 width="731" height="616">
	<mx:Script>
		<![CDATA[
			import org.apache.commons.scxml.model.SCXML;
			import org.apache.commons.scxml.model.events.SCXMLEvent;
			
			[Embed(source="../resources/assign.xml")]
			protected const scxmlDoc : Class;
			private var engine:SCXML=null;
			
			public function initPage():void {
				engine= new SCXML();
				var xml:XML=XML(scxmlDoc.data);
				document_show.text=xml;
				engine.source=xml;
				
				engine.addEventListener(SCXMLEvent.STATE_ENTERED,listener);
				engine.addEventListener(SCXMLEvent.FINAL_STATE_REACHED,finished);
				engine.start();
			}
			
			public function finished(event:SCXMLEvent):void{
				trace("Event:"+event.toString());
			}
			
			public function listener(event:SCXMLEvent):void{
				trace("State:"+event.stateId.toString());
				console.text=event.stateId.toString();
			}

			protected function eventadd_clickHandler(eve:MouseEvent):void
			{
				var event:String=event_source.text;
				if(event!=null&&event!=""){
					engine.send(event);
				}
			}
		]]>
	</mx:Script>
	
	<s:TextArea id="document_show" name="document_show" text="test" width="349" height="506" x="21" y="26"/>
	<s:TextInput id="event_source" x="400" y="48"/>
	<s:Button x="579" y="48" label="Event Add" width="75" height="22" click="eventadd_clickHandler(event)"/>
	<s:Label x="395" y="116" text="Current State:&#xd;" width="147" height="15"/>
	<s:TextArea id="console" x="400" y="148" width="287" height="104"/>
	
</mx:Application>

```