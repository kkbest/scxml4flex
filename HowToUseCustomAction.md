#Tell us how to use CustomAction in SCXML4Flex.

# SCXML document with custom action #

Support we have a SCXML document like this.
```
<scxml xmlns="http://www.w3.org/2005/07/scxml"
       xmlns:my="http://my.custom-actions.domain/CUSTOM"
       version="1.0"
       initialstate="custom">

    <state id="custom">

        <onentry>
            <my:hello name="Custom State" />
        </onentry>
		<transition event="helloevent" target="result"/>
    </state>
	
	<state id="result">
		<onentry>
            <my:hello name="Result State" />
        </onentry>
	</state>
</scxml>
```
my:hello is a custom action element, its namespace is
```
http://my.custom-actions.domain/CUSTOM
```
So, we have to do some extension job for this custom action element.

# 1.CustomAction class for my:hello element #

We should write an customaction class for this element, and this class should implements ExecuteContent interface, seems like this:
```
package
{
	import org.apache.commons.scxml.model.nodes.actions.ExecuteContent;
	import org.apache.commons.scxml.model.SCXMLDocument;
	import org.apache.commons.scxml.interfaces.IInterpreter;
	
	public class Hello implements ExecuteContent
	{
		public function Hello()
		{
		}
		
		public function execute(child : XML,doc : SCXMLDocument,interpreter : IInterpreter):Function{
			var label : String = child.hasOwnProperty("@name") ? child.@name + ": " : "Name property of Hello element: ";
			var f : Function = function() : void {
				trace("------CustomAction execute method:----------"+label);
			};
			return f;
		}
	}
}
```
We should override execute method, finish the function detail. In this demo custom action, it should output a property for my:hello element.

# 2.Add CustomAction for SCXML engine #
With the custom action(s) implemented, the document may be parsed using a custom SCXML digester that is aware of these actions like so:
```
var customActionList:Array = new Array();
				customActionList.push(new CustomAction("http://my.custom-actions.domain/CUSTOM","hello",new Hello()));
				
				engine= new SCXML();
				var xml:XML=XML(scxmlDoc.data);
				document_show.text=xml;
				engine.addCustomAction(customActionList);
				engine.source=xml;
				
				engine.addEventListener(SCXMLEvent.STATE_ENTERED,listener);
				engine.addEventListener(SCXMLEvent.FINAL_STATE_REACHED,finished);
				engine.start();
```