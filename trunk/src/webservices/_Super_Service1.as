/**
 * This is a generated class and is not intended for modfication.  To customize behavior
 * of this service wrapper you may modify the generated sub-class of this class - Service1.as.
 */
package webservices
{
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.services.wrapper.WebServiceWrapper;
import com.adobe.serializers.utility.TypeUtility;
import flash.utils.ByteArray;
import mx.collections.ArrayCollection;
import mx.rpc.AbstractOperation;
import mx.rpc.AsyncToken;
import mx.rpc.soap.mxml.Operation;
import mx.rpc.soap.mxml.WebService;
import valueObjects.NextPhaseXML;

[ExcludeClass]
internal class _Super_Service1 extends com.adobe.fiber.services.wrapper.WebServiceWrapper
{
     
    // Constructor
    public function _Super_Service1()
    {
        // initialize service control
        _serviceControl = new mx.rpc.soap.mxml.WebService();
        var operations:Object = new Object();
        var operation:mx.rpc.soap.mxml.Operation;
         
        operation = new mx.rpc.soap.mxml.Operation(null, "GetAvailableCategories");
		 operation.resultElementType = String;
        operations["GetAvailableCategories"] = operation;
    
        operation = new mx.rpc.soap.mxml.Operation(null, "GetLatestNewsItems");
		 operation.resultType = valueObjects.NextPhaseXML; 		 
        operations["GetLatestNewsItems"] = operation;
    
        operation = new mx.rpc.soap.mxml.Operation(null, "GetNewsItems");
		 operation.resultType = valueObjects.NextPhaseXML; 		 
        operations["GetNewsItems"] = operation;
    
        operation = new mx.rpc.soap.mxml.Operation(null, "GetNumberOfNewNewsItems");
		 operation.resultType = int; 		 
        operations["GetNumberOfNewNewsItems"] = operation;
    
        operation = new mx.rpc.soap.mxml.Operation(null, "GetAvailableLanguages");
		 operation.resultElementType = String;
        operations["GetAvailableLanguages"] = operation;
    
        operation = new mx.rpc.soap.mxml.Operation(null, "GetASRResult");
		 operation.resultElementType = String;
        operations["GetASRResult"] = operation;
    
        _serviceControl.operations = operations;
        try
        {
            _serviceControl.convertResultHandler = com.adobe.serializers.utility.TypeUtility.convertResultHandler;
        }
        catch (e: Error)
        { /* Flex 3.4 and eralier does not support the convertResultHandler functionality. */ }

  

        _serviceControl.service = "Service1";
        _serviceControl.port = "Service1Soap";
        wsdl = "http://ns365027.ovh.net/NextPhaseWS/Service1.asmx?WSDL";
        model_internal::loadWSDLIfNecessary();
      
     
        model_internal::initialize();
    }

	/**
	  * This method is a generated wrapper used to call the 'GetAvailableCategories' operation. It returns an mx.rpc.AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function GetAvailableCategories(language:String) : mx.rpc.AsyncToken
	{
		model_internal::loadWSDLIfNecessary();
		var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetAvailableCategories");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(language) ;

		return _internal_token;
	}   
	 
	/**
	  * This method is a generated wrapper used to call the 'GetLatestNewsItems' operation. It returns an mx.rpc.AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function GetLatestNewsItems(language:String, category:String, number:int) : mx.rpc.AsyncToken
	{
		model_internal::loadWSDLIfNecessary();
		var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetLatestNewsItems");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(language,category,number) ;

		return _internal_token;
	}   
	 
	/**
	  * This method is a generated wrapper used to call the 'GetNewsItems' operation. It returns an mx.rpc.AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function GetNewsItems(language:String, category:String, afterTimestamp:Date) : mx.rpc.AsyncToken
	{
		model_internal::loadWSDLIfNecessary();
		var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetNewsItems");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(language,category,afterTimestamp) ;

		return _internal_token;
	}   
	 
	/**
	  * This method is a generated wrapper used to call the 'GetNumberOfNewNewsItems' operation. It returns an mx.rpc.AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function GetNumberOfNewNewsItems(language:String, category:String, afterTimestamp:Date) : mx.rpc.AsyncToken
	{
		model_internal::loadWSDLIfNecessary();
		var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetNumberOfNewNewsItems");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(language,category,afterTimestamp) ;

		return _internal_token;
	}   
	 
	/**
	  * This method is a generated wrapper used to call the 'GetAvailableLanguages' operation. It returns an mx.rpc.AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function GetAvailableLanguages() : mx.rpc.AsyncToken
	{
		model_internal::loadWSDLIfNecessary();
		var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetAvailableLanguages");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send() ;

		return _internal_token;
	}   
	 
	/**
	  * This method is a generated wrapper used to call the 'GetASRResult' operation. It returns an mx.rpc.AsyncToken whose 
	  * result property will be populated with the result of the operation when the server response is received. 
	  * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
	  * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
	  */          
	public function GetASRResult(audioData:ByteArray, phrases:ArrayCollection) : mx.rpc.AsyncToken
	{
		model_internal::loadWSDLIfNecessary();
		var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("GetASRResult");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(audioData,phrases) ;

		return _internal_token;
	}   
	 
}

}
