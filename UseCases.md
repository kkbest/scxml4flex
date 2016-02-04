#Add some use cases for SCXML4Flex



# Stop Watch Demo #
You can find some other similar stop watch demo, such as [Apache Commons SCXML stop watch demo](http://commons.apache.org/scxml/usecases/scxml-stopwatch.html) to learn more.

## Sample walkthrough - From model to working code ##

Here is a short exercise in modeling and implementing an object with stateful behavior. A stopwatch -- for anyone who may need an introduction -- is used to measure duration, with one button for starting and stopping the watch and another one for pausing the display (also known as "split", where the watch continues to keep time while the display is frozen, to measure, for example, "lap times" in races). Once the watch has been stopped, the start/stop button may be used to reset the display.

## The SCXML document ##
The SCXML document is then, a simple serialization of the "model" above: [stopwatch.xml](http://scxml4flex.googlecode.com/svn/trunk/scxml4flex/resources/stopwatch.xml).

## The Stopwatch UI ##
Here is the class that implements the stopwatch behavior, [StopWatchDemo.mxml](http://scxml4flex.googlecode.com/svn/trunk/scxml4flex/src/StopWatchDemo.mxml). The flex mxml provides one approach for providing the base functionality needed by classes representing stateful entities. Points to note in the StopWatch class are:
  * The "lifecycle" is defined by the SCXML document, which is an artifact easily derived from the modeling layer.
  * The code is much simpler, since the lifecycle management task has been assigned to SCXML4Flex.