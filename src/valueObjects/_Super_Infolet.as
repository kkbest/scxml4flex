/**
 * This is a generated class and is not intended for modfication.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Infolet.as.
 */

package valueObjects
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.IValueObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import mx.events.PropertyChangeEvent;
import valueObjects.Data;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[ExcludeClass]
public class _Super_Infolet extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void 
    {
    }   
     
    model_internal static function initRemoteClassAliasAllRelated() : void 
    {
        valueObjects.Data.initRemoteClassAliasSingleChild();
    }

	model_internal var _dminternal_model : _InfoletEntityMetadata;

	/**
	 * properties
	 */
	private var _internal_title : String;
	private var _internal_ingress : String;
	private var _internal_body : String;
	private var _internal_data : valueObjects.Data;
	private var _internal_url : String;
	private var _internal_image : String;
	private var _internal_time : String;

    private static var emptyArray:Array = new Array();

    /**
     * derived property cache initialization
     */  
    model_internal var _cacheInitialized_isValid:Boolean = false;   
    
	model_internal var _changeWatcherArray:Array = new Array();   

	public function _Super_Infolet() 
	{	
		_model = new _InfoletEntityMetadata(this);
	
		// Bind to own data properties for cache invalidation triggering  
       
	}

    /**
     * data property getters
     */
	[Bindable(event="propertyChange")] 
    public function get title() : String    
    {
            return _internal_title;
    }    
	[Bindable(event="propertyChange")] 
    public function get ingress() : String    
    {
            return _internal_ingress;
    }    
	[Bindable(event="propertyChange")] 
    public function get body() : String    
    {
            return _internal_body;
    }    
	[Bindable(event="propertyChange")] 
    public function get data() : valueObjects.Data    
    {
            return _internal_data;
    }    
	[Bindable(event="propertyChange")] 
    public function get url() : String    
    {
            return _internal_url;
    }    
	[Bindable(event="propertyChange")] 
    public function get image() : String    
    {
            return _internal_image;
    }    
	[Bindable(event="propertyChange")] 
    public function get time() : String    
    {
            return _internal_time;
    }    

    /**
     * data property setters
     */      
    public function set title(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_title == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_title;               
        if (oldValue !== value)
        {
            _internal_title = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "title", oldValue, _internal_title));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set ingress(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_ingress == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_ingress;               
        if (oldValue !== value)
        {
            _internal_ingress = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "ingress", oldValue, _internal_ingress));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set body(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_body == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_body;               
        if (oldValue !== value)
        {
            _internal_body = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "body", oldValue, _internal_body));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data(value:valueObjects.Data) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:valueObjects.Data = _internal_data;               
        if (oldValue !== value)
        {
            _internal_data = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data", oldValue, _internal_data));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set url(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_url == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_url;               
        if (oldValue !== value)
        {
            _internal_url = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "url", oldValue, _internal_url));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set image(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_image == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_image;               
        if (oldValue !== value)
        {
            _internal_image = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "image", oldValue, _internal_image));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set time(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_time == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_time;               
        if (oldValue !== value)
        {
            _internal_time = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "time", oldValue, _internal_time));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    

    /**
     * data property setter listeners
     */   

   model_internal function setterListenerAnyConstraint(value:flash.events.Event):void
   {
        if (model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }        
   }   

    /**
     * valid related derived properties
     */
    model_internal var _isValid : Boolean;
    model_internal var _invalidConstraints:Array = new Array();
    model_internal var _validationFailureMessages:Array = new Array();

    /**
     * derived property calculators
     */

    /**
     * isValid calculator
     */
    model_internal function calculateIsValid():Boolean
    {
        var violatedConsts:Array = new Array();    
        var validationFailureMessages:Array = new Array();    

		if (_model.isTitleAvailable && _internal_title == null)
		{
			violatedConsts.push("titleIsRequired");
			validationFailureMessages.push("title is required");
		}
		if (_model.isIngressAvailable && _internal_ingress == null)
		{
			violatedConsts.push("ingressIsRequired");
			validationFailureMessages.push("ingress is required");
		}
		if (_model.isBodyAvailable && _internal_body == null)
		{
			violatedConsts.push("bodyIsRequired");
			validationFailureMessages.push("body is required");
		}
		if (_model.isDataAvailable && _internal_data == null)
		{
			violatedConsts.push("dataIsRequired");
			validationFailureMessages.push("data is required");
		}
		if (_model.isUrlAvailable && _internal_url == null)
		{
			violatedConsts.push("urlIsRequired");
			validationFailureMessages.push("url is required");
		}
		if (_model.isImageAvailable && _internal_image == null)
		{
			violatedConsts.push("imageIsRequired");
			validationFailureMessages.push("image is required");
		}
		if (_model.isTimeAvailable && _internal_time == null)
		{
			violatedConsts.push("timeIsRequired");
			validationFailureMessages.push("time is required");
		}

		var styleValidity:Boolean = true;
	
	
	
	
	
	
	
    
        model_internal::_cacheInitialized_isValid = true;
        model_internal::invalidConstraints_der = violatedConsts;
        model_internal::validationFailureMessages_der = validationFailureMessages;
        return violatedConsts.length == 0 && styleValidity;
    }  

    /**
     * derived property setters
     */

    model_internal function set isValid_der(value:Boolean) : void
    {
       	var oldValue:Boolean = model_internal::_isValid;               
        if (oldValue !== value)
        {
        	model_internal::_isValid = value;
        	_model.model_internal::fireChangeEvent("isValid", oldValue, model_internal::_isValid);
        }        
    }

    /**
     * derived property getters
     */

    [Transient] 
	[Bindable(event="propertyChange")] 
    public function get _model() : _InfoletEntityMetadata
    {
		return model_internal::_dminternal_model;              
    }	
    
    public function set _model(value : _InfoletEntityMetadata) : void       
    {
    	var oldValue : _InfoletEntityMetadata = model_internal::_dminternal_model;               
        if (oldValue !== value)
        {
        	model_internal::_dminternal_model = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_model", oldValue, model_internal::_dminternal_model));
        }     
    }      

    /**
     * methods
     */  


    /**
     *  services
     */                  
     private var _managingService:com.adobe.fiber.services.IFiberManagingService;
    
     public function set managingService(managingService:com.adobe.fiber.services.IFiberManagingService):void
     {
         _managingService = managingService;
     }                      
     
    model_internal function set invalidConstraints_der(value:Array) : void
    {  
     	var oldValue:Array = model_internal::_invalidConstraints;
     	// avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_invalidConstraints = value;   
			_model.model_internal::fireChangeEvent("invalidConstraints", oldValue, model_internal::_invalidConstraints);   
        }     	             
    }             
    
     model_internal function set validationFailureMessages_der(value:Array) : void
    {  
     	var oldValue:Array = model_internal::_validationFailureMessages;
     	// avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_validationFailureMessages = value;   
			_model.model_internal::fireChangeEvent("validationFailureMessages", oldValue, model_internal::_validationFailureMessages);   
        }     	             
    }        
     
     // Individual isAvailable functions     
	// fields, getters, and setters for primitive representations of complex id properties

}

}
