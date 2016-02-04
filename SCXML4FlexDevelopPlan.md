# Flex/ActionScript SCXML engine project proposal #

## The Problem ##
Flex/ActionScript has been widely used to develop some cartoon applications, which executes a character or something moving on the computer screen. Recently, I noticed that [State Chart XML](http://www.w3c.org/TR/scxml) seems to be a good solution for this kind of application, because it can control state and transition very well. Unfortunately, I was not able to get any good ActionScript based SCXML engine. I advise that it would make sense to develop such a kind of actionscript based SCXML engine to help with executing a state machine defined using a SCXML document.
## The Proposal ##
Our team began to make it happen, and named the project [SCXML4Flex](http://code.google.com/p/scxml4flex/). It has launch to implement many SCXML elements, such as scxml, state, transition, final, history, parallel, onentry, onexit, data, invoke, log, assign, raise, script, cancel, param, send,if, elseif, else and finish [CustomAction support](http://code.google.com/p/scxml4flex/wiki/HowToUseCustomAction). Currently, it is a usable ActionScript SCXML engine, which can handler basic SCXML service. You could check SCXML4Flex [demos here](http://scxml4as.appspot.com/).

SCXML4Flex is still in its infancy, and it will have a long way to go in order to be perfect. There are four parts to work on in the future as follow: Basic element implementation, XInclude support, XPath support and Event IO processor.

# Future Plan #

## 1. Basic elements implementation ##
SCXML4Flex has already implemented many elements for SCXML already, but we should go head in this way, there are still some elements that were not implemented yet:
  * validate element
  * donedate element
  * content element
  * param element
  * finalize element
Note: Implementation of donedate,content,param,finalize elements are some kind of depended on the implementation of Event IO processor.

## 2. System variables implementation ##
The Data Module maintains a protected portion of the data model containing information that may be useful to applications. We refer the items in this special part of the data model as 'system variables'. Implementations must provide the following system variables:
  * `_event`
  * `_sessionid`
  * `_name`
  * `_x`
The set of system variables may be expanded in future versions of this specification. Variable names beginning with  `_`  are reserved for system use. Developers must not use ids beginning with  `_` in the < data > element. We can check [here](http://www.w3.org/TR/scxml/#SystemVariables) to get more information about system variables.

## 3. XInclude support ##
We usually use XInclude to merge several XML document into one whole document.
```
<?xml version="1.0" encoding="utf-8" ?>
<data xmlns:xi="http://www.w3.org/2001/XInclude">
		<item><xi:include href="books.xml" xpointer="/bookstore/book[1]/title"/></item>
		<item><xinclude href="books.xml" xpointer="/bookstore/book/price/text()"/></item>
		<item><xinclude href="books.xml" xpointer="/bookstore/book[price>35]/price"/></item>
		<item><xi:include href="books.xml" xpointer="/bookstore/book[price>35]/title"/></item>
	</bookTests>
	<item>data 1</item>
	<item>data 2</item>
	<xinclude href="Test2Doc.xml" xpointer="/path/to/evaluate"/>
	<xi:include href="Test2Doc.xml" xpointer="//*"/>
</data>
```
XInclude includes several attribute, XPointer is the most difficult part for us. I think we can choose a open source XPath engine and finish XPointer and XInclude implementation base on it.

## 4. XPath support ##
XPath plays a significant role in any XML document and also in SCMXL document.
### 4.1 The XPath Data Model in SCXML ###
In SCXML's [XPath data model](http://www.w3.org/TR/scxml/#xpath-profile), XPath 2.0 expressions are used to select a node-set from the data model by providing a binding expression. The following example illustrates this usage:
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
### 4.2 Conditional Expressions in SCXML ###
XPath 2.0 expressions used in conditional expressions, which are converted into their effective boolean value as described XPath 2.0 specification. The following example illustrates this usage.
```
<state id="errorSwitch" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <datamodel>
    <data id="time"/>
  </datamodel>
          
  <onentry>
    <assign location="$time" expr="fn:current-dateTime()"/>
  </onentry>
          
  <transition cond="fn:year-from-dateTime($time) > 2009" target="newBehavior"/>
  <transition target="currentBehavior"/>
</state>
```
In this section, we should finish all the XPath 2.0 functions implementation job and I have started this part of job, working for functions implementation, we can check [here](http://code.google.com/p/scxml4flex/wiki/XPath2FunctionsForConditionalExpressions) to get XPath 2.0 functions implementation progress.
### 4.3 XPath in XInclude ###
As we mentioned above, XInclude use XPath to build XPointer element.

## 5. Event IO processor ##

SCXML's Event I/O Processors is individed into three components.
### 5.1 SCXML Event I/O Processor ###
The SCXML Event I/O Processor is intended to transport messages in a specific format to and from SCXML sessions.
Here is a message with an XML payload generated by `<send>` with a 'namelist':
```
<datamodel>
  <data id="email" expr="'mailto:recipient@example.com'"/>
  <data id="content" expr="'http://www.example.com/mycontent.txt'"/>
  <data id="xmlcontent">
    <headers xmlns="http://www.example.com/headers">
      <cc>archive@example.com</cc>
      <subject>Example email</subject>
    </headers>
  </data>
</datamodel>

<send id="send-123"
      target="http://scxml-processors.example.com/session2"
      type="scxml" event="email.send"
      namelist="email content xmlcontent"
      hints="Email headers"/>
```
Here is the actual XML message that will be sent over platform-specific transport and converted into an event in the target SCXML session:
```
<scxml:message sendid="send-123" name="email.send">
  <scxml:payload>
    <scxml:property name="email">mailto:recipient@example.com</scxml:property>
    <scxml:property name="content">http://www.example.com/mycontent.txt</scxml:property>
    <scxml:property name="xmlcontent">
      <scxml:hint>Email headers</scxml:hint>
      <headers xmlns="http://www.example.com/headers">
        <cc>archive@example.com</cc>
        <subject>Example email</subject>
      </headers>
    </scxml:property>
  </scxml:payload>
</scxml:message>
```
Here is sample SCXML code to process that event in the receiving SCXML session. In this example `<my:email>` is platform-specific executable content that sends an email:
```
<scxml:transition event="email.send">
  <my:email to="data('_event')/scxml:property[@name='email']"
            cc="data('_event')/scxml:property[@name='xmlcontent']/h:headers/h:cc"
            subject="data('_event')/scxml:property[@name='xmlcontent']/h:headers/h:subject"
            content="data('_event')/scxml:property[@name='content']"/>
</scxml:transition>
```

### 5.2 Basic HTTP Event I/O Processor ###
The Basic HTTP Event I/O Processor is intended as a minimal interoperable mechanism for sending and receiving events between external components and SCXML 1.0 implementations. Support for the Basic HTTP Event I/O Processor is optional, but implementations that implement this processor must support sending and receiving messages in the SCXML message format using it().

### 5.3 DOM Event I/O Processor ###
The DOM Event I/O processor handles communication between SCXML markup and markup in other namespaces in mixed-markup XML documents. An example of this would be a document containing both SCXML and HTML markup. In such a case, each language retains its own context and its own independent semantics. (For example, SCXML's event processing algorithm is not affected by the fact that there is HTML markup elsewhere in the document.) It is however useful for the two languages to be able to communicate by sending events back and forth, so that the HTML markup can notify SCXML when the user clicks on a button, and the SCXML markup can notify HTML when it is time to place a certain field in focus, etc. The DOM Event I/O processor handles this communication by means of DOM Events [DOMEvents](DOMEvents.md), which are a general means for information propagation in XML documents.