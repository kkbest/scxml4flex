#Introduce custom action in SCXML specification

# What is a 'custom action'? #

Actions are SCXML elements that "do" something. Actions can be used where "executable content" is permissible, for example, within onentry, onexit and transition  elements.

The SCXML specification (currently a Working Draft) defines a set of "standard actions". These include var, assign, log, send, cancel, if, elseif and else.

The specification also allows implementations to define "custom actions" in addition to the standard actions. What such actions "do" is upto the author of these actions, and these are therefore called "custom" since they are tied to a specific implementation of the SCXML specification.

# What can be done via a custom action #

A custom action in the Commons SCXML implementation has access to:

  * The current Context (and hence, the values of variables in the current Context).
  * Any other Context within the document, provided the id of the parent state is known.
  * The expression Evaluator for this document, and hence the ability to evaluate a given expression against the current or a identifiable Context.
  * The list of other actions in this Executable .
  * The "root" Context, to examine any variable values in the "document environment".
  * The EventDispatcher, to send or cancel events.
  * The ErrorReporter, to report any errors (that the ErrorReporter knows how to handle).
  * The histories, for any identifiable history.
  * The NotificationRegistry, to obtain the list of listeners attached to identifiable "observers".
  * The engine log, to log any information it needs to.

Lets walk through the development of a simple, custom "hello world" action by HowToUseCustomAction.