This article tell us SCXML4Flex's XPath 2.0 support condition in Conditional Expressions, such as:

in assign element
```
<assign location="$time" expr="fn:current-dateTime()"/>
```
in transition element
```
<transition cond="fn:year-from-dateTime($time) > 2009" target="newBehavior"/>
```
or in if,elseif element.




# Support Elements #

## XPath 2.0 Functions ##

  * contains
  * starts-with
  * ends-with
  * substring-before

Note: we should replace  - with\_in SCXML document, for example use starts\_with replace starts-with in SCXML4Flex, it is a small bug
## Other ##

coming soon...