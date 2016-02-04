# Introduction #

Apache Tapestry supplies powerful component structure, and it offered a number of other
powerful features that proved to be critical in our work.

[The Eclipse Web Tools Platform (WTP) project](http://www.eclipse.org/webtools/) extends the Eclipse
platform with tools for developing Web and Java EE applications. It
includes source and graphical editors for a variety of languages,
wizards and built-in applications to simplify development, and tools
and APIs to support deploying, running, and testing apps.WTP supplies Web Page Editor for us to edit HTML page, JSP page and
JSF-JSP web page.

Tapestry was used widely nowadays, it allowed a clean separation between Java and HTML, and made it possible for the design work on the application to continue well after the code had been completed, It is becoming more and more popular today. But we can not find a proper Tapestry visual editor, Eclipse WTP is popular in Web application development, but it is a shame that Eclipse WTP does not support Tapestry, so i think it is a good idea to build a Tapestry visual editor on Eclipse WTP.

This editor should have following mainly functions:

**Note** GSoC supplies us only 3 months to finish our project, so this project will focus on Tapestry 5, after that, if we have enough time, will supply other Tapestry version support

## Must have functions ##
1. Tapertry libraries import wizard

Add necessary Tapestry 5 relative jars into web project.

2. Tapestry page/component creation wizard

It will supply a wizard helping us to create the .tml file and .java
file together  for a Tapestry page/component.

3. Add Tapestry component support for WTP web editor palette

If we open a Tapestry page/component with WTP Web Page Editor, its
palette will contains three main section, HTML,Tapestry core and
Tapestry custom component. Then, we can drap-and-drop the components
in the palette to the canvas. WTP web editor supplies property view
for us already, we can improve the property to support Tapestry
component.
In Tapestry Core section, it includes Tapestry standard components,
Foreach, Insert,Image,Conditional, Form components and the other
standard components.

**NOTE** Eclipse WTP supplies relative interface for us to change
palette components

4. Add convenient way for the Web Page Editor to change-over between a
Tapestry page's .tml file and .java file

5. Add Tapestry built in and custom components autocomplete function
for WTP Web Page Editor's source view

If we add component insert code, such as
```
<span jwcid="@Insert"/>
```
,So when you type
```
<span jwcid="@
```
it comes up with a list you can choose from and then completes it with the required parameters listed.

6.Tapestry component's parameters property view

We select a component in canvas design view or source view, the
Eclipse property view will list this component's parameters and we can
edit the parameters here.

7.Autocomplete of properties from the .java page when editing the .tml file

In the Source Page of the Web Page Editor, add the Tapestry tag, (for
example ${prop:index}). With the cursor inside the brackets, hit
Ctrl+spacebar, should see a pop-up with a list of all the available
properties defined in the corresponding java class.

## Optional features ##
8. Validation function in Tapestry .tml file source view

Beyond the basic JSP validation already provided with the JSP editor,
this editor supplies semantic validation of the Tapestry standard tag
libraries for both EL and non-EL attribute values.

9. Hyperlink function in Tapestry .tml file source view

Hyperlink to the Java editor from Managed Bean variable, Managed Bean
property and Managed Bean method referenced in the Expression
Language(EL) of a tag-attribute.

I have finished some research job and familiar with Eclipse WTP source
code, so i think it is definitely for us to finish function 1-7 during
this summer. Function 8 and 9 are more complex and not so necessary,
so i mark them as optional features. Once i finished must-have functions development job, i will start option features job.

# Online design demo #
You can go [here](http://visual-tapestry.appspot.com/) to see project proposal details with picture demos.

# Additional Info #
## Things i have done already ##

I have been working with both Eclipse and Tapestry for years, have much Eclipse plug-in development experience. Have subscribed Eclipse WTP and Tapestry mail list,discuss technology details in the mail lists. As GSoC suggested it, mail list is really a good place to discuss project ideas and some other details. I use the mail lists whenever possible to clarify the doubts by asking questions from the experts.Feedback that i received from mail lists helps me so much, thanks for self-giving open source developers and open source spirit.

## Time Schedule ##

  * March 28 - April 8: Submitting the project proposal
  * April 26 - May 24:Community Bonding Period (April 26 - May 24): Get to know mentors, read documentation, and prepare development environment.
  * May 23 - May 31: Finish Tapertry libraries import wizard function
  * Jun 1 - Jun 8: Finish Tapestry page/component creation wizard function
  * Jun 9 - Jun 24: Finish Add Tapestry component support for WTP web editor palette function
  * Jun 25 - Jul 2: Finish change-over function between Tapestry page's .tml file and .java file
  * Jul 3 - Jul 12: Add Tapestry built in and custom components autocomplete function for WTP Web Page Editor's source view
  * Jul 13 - Jul 20: Finish Tapestry component's parameters property view
  * Jul 21 - Aug 6: Finish Autocomplete of properties from the .java page when editing the .tml file function
  * Aug 7 - Aug 16: Develop time for both Optional features 8 and 9 (Validation function in Tapestry .tml file source view & Hyperlink function in Tapestry .tml file source view)
  * Aug 17 - Aug 22: Scrub code, write tests, improve documentation and submit all my work

## Something about me: ##

My name is Gavin Lei.My major is computer scienece and technology,and i am a postgraduate student of University of Science and Technology Beijing.I am familar with Eclipse,Java,ActionScript,Flex,SCXML,XML,XSL and some other open source projects,such as struts,spring,jstl,dojo and so on and have several years of Java development experience.I am familiar with many project in Apache Foundation,Eclipse Foundation as well as Dojo Foundation .

My e-mail is gavingui2011@gmail.com, and my mobile phone number is +8615810117210. When i was working in IBM China,my mentor helped me a lot and know me well, if you are interested, my mentors may give you some impersonal evaluation about my ability and others.
My mentor in IBM China Develop Lab: Qian Liang/Email:liangq@cn.ibm.com

## My open source development experience ##

  * Built a tool for struts2 to generate XML config file
  * Develop a Eclipse plugin for Apache SCXML engine which was a visualizing tool for navigating and editing complex SCXML state description XML.

## What i did in my student period ##

  * 2008.7 - 2010.8 : Work in IBM China Research Laborary,my team focus on telecom J2EE solution,get lots of XML relative knowledge
  * 2010.9: Won IBM Blue Pathway Excellment team member 2010
  * 2010.8 - 2011.3 : Work in IBM China Development Laborary as a intern