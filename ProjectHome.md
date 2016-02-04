This project supplies an ActionScript based SCXML engine.



[State Chart XML (SCXML)](http://www.w3.org/TR/scxml) is currently a Working Draft published by the World Wide Web Consortium (W3C). SCXML provides a generic state-machine based execution environment based on Harel State Tables. SCXML is a candidate for the control language within multiple markup languages coming out of the W3C (see Working Draft for details).

SCXML4Flex is an implementation aimed at creating and maintaining an ActionScript based SCXML engine capable of executing a state machine defined using a SCXML document, while abstracting out the environment interfaces.Combine your statecharts with UIComponent states for the true top-down approach to Flex coding.

# Getting started #

SCXML4Flex is distributed for Flex 3 or greater, you can download the .swc file and import it into your project build path or compile your project with SCXML4Flex's [source code](http://code.google.com/p/scxml4flex/source/checkout).

Suppose that we have a SCXML document like this:
```
<scxml initial="loop" >
    <datamodel>
        <data id="x" expr="6"/>
        <data id="fac" expr="1"/>
    </datamodel> 
    <state id="loop">
        <onentry>
            <log label="'X'" expr="x"/>
        </onentry>
        <transition cond="x &gt; 1">
            <assign location="fac" expr="x * fac"/>
            <assign location="x" expr="x-1"/>
        </transition>
        <transition target="result">
            <log label="'Result'" expr="fac"/>
        </transition>
    </state>
   <final id="result"/>
</scxml>
```
And we want to parse this document and check the result, use these ActionScript codes:
```
  var engine:SCXML= new SCXML();
  var xml:XML=XML(scxmlDoc.data);
  engine.source=xml;
  engine.start();
```
Then, we can find the following output info in Flash Builder console if you debug this application:
```
'X': 6
'Result': 720
```
## Supported Elements ##

SCXML4Flex has implemented most of SCXML specification elements:
```
scxml
state
transition
final
history
parallel
onentry
onexit
data
invoke
finalize
log
assign
raise
script
cancel
param
send
if
elseif
else
```

# Using the data element #

## The ECMAScript Data Model ##
SCXML4Flex support datamodel and data element already, we can define data in SCXML document, change data value by assign , script or some other elements.
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

## The XPath Data Model ##
### Conditional Expressions ###
XPath 2.0 expressions used in conditional expressions are converted into their effective boolean value as described in XPath 2.0 specification. The following example illustrates this usage.
```
<state id="errorSwitch" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <datamodel>
    <data id="time"/>
  </datamodel>
          
  <onentry>
    <assign location="time" expr="current-dateTime()"/>
  </onentry>
          
  <transition cond="year-from-dateTime($time) > 2009" target="newBehavior"/>
  <transition target="currentBehavior"/>
</state>
```
Conditional expressions may take advantage of the scxml:In() predicate. It is used to check whether it is in special state.

You can check XPath 2.0 functions implementation detail [here](http://code.google.com/p/scxml4flex/wiki/XPath2FunctionsForConditionalExpressions).

### Location Expressions ###
XPath 2.0 expressions are used to select a node-set from the data model by providing a binding expression. The following example illustrates this usage:
```
<state id="errorSwitch">
  <datamodel>
    <data id="cities">
      <list xmlns="">
        <city id="nyc" count="0">New York</city>
        <city id="bos" count="0">Boston</city>
      </list>
    </data>
  </datamodel>

  <onentry>
    <assign location="$cities/list/city[@id='nyc']/@count" expr="1"/>
  </onentry>
</state>
```
Note:Not support yet, we are working about this functions. It will coming soon...

# Contexts and Evaluators #
The SCXML specification allows implementations to support multiple expression languages to enable using SCXML documents in varying environments. These expressions become part of attribute values for executable content, such as:
```
<datamodel>
	<data id="y" expr="4"/>
	<data id="x" expr="1+2+y"/>
</datamodel> 
```
SCXML4Flex use D.eval library for expression parse job.

# Using custom actions #

Actions are SCXML elements that "do" something. Actions can be used where "executable content" is permissible, for example, within onentry, onexit and transition  elements.

The SCXML specification (currently a Working Draft) defines a set of "standard actions". These include var, assign, log, send, cancel, if, elseif and else.

The specification also allows implementations to define "custom actions" in addition to the standard actions. What such actions "do" is upto the author of these actions, and these are therefore called "custom" since they are tied to a specific implementation of the SCXML specification.

Go through HowToUseCustomAction to learn how to use Custom Action in SCXML4Flex.

# Involve in SCXML4Flex #

If you have any problems or questions about SCXML4Flex, you can disucss these topics in [SCXML4Flex mail list](http://groups.google.com/group/scxml4flex), it is a google group, you can join it if you have a google account.