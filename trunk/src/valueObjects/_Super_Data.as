/**
 * This is a generated class and is not intended for modfication.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Data.as.
 */

package valueObjects
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.IValueObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import mx.events.PropertyChangeEvent;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[ExcludeClass]
public class _Super_Data extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void 
    {
    }   
     
    model_internal static function initRemoteClassAliasAllRelated() : void 
    {
    }

	model_internal var _dminternal_model : _DataEntityMetadata;

	/**
	 * properties
	 */
	private var _internal_data1 : String;
	private var _internal_data2 : String;
	private var _internal_data3 : String;
	private var _internal_data4 : String;
	private var _internal_data5 : String;
	private var _internal_data6 : String;
	private var _internal_data7 : String;
	private var _internal_data8 : String;
	private var _internal_data9 : String;

    private static var emptyArray:Array = new Array();

    /**
     * derived property cache initialization
     */  
    model_internal var _cacheInitialized_isValid:Boolean = false;   
    
	model_internal var _changeWatcherArray:Array = new Array();   

	public function _Super_Data() 
	{	
		_model = new _DataEntityMetadata(this);
	
		// Bind to own data properties for cache invalidation triggering  
       
	}

    /**
     * data property getters
     */
	[Bindable(event="propertyChange")] 
    public function get data1() : String    
    {
            return _internal_data1;
    }    
	[Bindable(event="propertyChange")] 
    public function get data2() : String    
    {
            return _internal_data2;
    }    
	[Bindable(event="propertyChange")] 
    public function get data3() : String    
    {
            return _internal_data3;
    }    
	[Bindable(event="propertyChange")] 
    public function get data4() : String    
    {
            return _internal_data4;
    }    
	[Bindable(event="propertyChange")] 
    public function get data5() : String    
    {
            return _internal_data5;
    }    
	[Bindable(event="propertyChange")] 
    public function get data6() : String    
    {
            return _internal_data6;
    }    
	[Bindable(event="propertyChange")] 
    public function get data7() : String    
    {
            return _internal_data7;
    }    
	[Bindable(event="propertyChange")] 
    public function get data8() : String    
    {
            return _internal_data8;
    }    
	[Bindable(event="propertyChange")] 
    public function get data9() : String    
    {
            return _internal_data9;
    }    

    /**
     * data property setters
     */      
    public function set data1(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data1 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data1;               
        if (oldValue !== value)
        {
            _internal_data1 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data1", oldValue, _internal_data1));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data2(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data2 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data2;               
        if (oldValue !== value)
        {
            _internal_data2 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data2", oldValue, _internal_data2));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data3(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data3 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data3;               
        if (oldValue !== value)
        {
            _internal_data3 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data3", oldValue, _internal_data3));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data4(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data4 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data4;               
        if (oldValue !== value)
        {
            _internal_data4 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data4", oldValue, _internal_data4));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data5(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data5 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data5;               
        if (oldValue !== value)
        {
            _internal_data5 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data5", oldValue, _internal_data5));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data6(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data6 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data6;               
        if (oldValue !== value)
        {
            _internal_data6 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data6", oldValue, _internal_data6));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data7(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data7 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data7;               
        if (oldValue !== value)
        {
            _internal_data7 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data7", oldValue, _internal_data7));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data8(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data8 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data8;               
        if (oldValue !== value)
        {
            _internal_data8 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data8", oldValue, _internal_data8));
        }    	     
        
        if (recalcValid && model_internal::_cacheInitialized_isValid)
        {
            model_internal::isValid_der = model_internal::calculateIsValid();
        }  
    }    
    public function set data9(value:String) : void 
    {    	
        var recalcValid:Boolean = false;
    	if (value == null || _internal_data9 == null)
    	{
    		recalcValid = true;
    	}	
    	
    	
    	var oldValue:String = _internal_data9;               
        if (oldValue !== value)
        {
            _internal_data9 = value;
        	this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "data9", oldValue, _internal_data9));
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

		if (_model.isData1Available && _internal_data1 == null)
		{
			violatedConsts.push("data1IsRequired");
			validationFailureMessages.push("data1 is required");
		}
		if (_model.isData2Available && _internal_data2 == null)
		{
			violatedConsts.push("data2IsRequired");
			validationFailureMessages.push("data2 is required");
		}
		if (_model.isData3Available && _internal_data3 == null)
		{
			violatedConsts.push("data3IsRequired");
			validationFailureMessages.push("data3 is required");
		}
		if (_model.isData4Available && _internal_data4 == null)
		{
			violatedConsts.push("data4IsRequired");
			validationFailureMessages.push("data4 is required");
		}
		if (_model.isData5Available && _internal_data5 == null)
		{
			violatedConsts.push("data5IsRequired");
			validationFailureMessages.push("data5 is required");
		}
		if (_model.isData6Available && _internal_data6 == null)
		{
			violatedConsts.push("data6IsRequired");
			validationFailureMessages.push("data6 is required");
		}
		if (_model.isData7Available && _internal_data7 == null)
		{
			violatedConsts.push("data7IsRequired");
			validationFailureMessages.push("data7 is required");
		}
		if (_model.isData8Available && _internal_data8 == null)
		{
			violatedConsts.push("data8IsRequired");
			validationFailureMessages.push("data8 is required");
		}
		if (_model.isData9Available && _internal_data9 == null)
		{
			violatedConsts.push("data9IsRequired");
			validationFailureMessages.push("data9 is required");
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
    public function get _model() : _DataEntityMetadata
    {
		return model_internal::_dminternal_model;              
    }	
    
    public function set _model(value : _DataEntityMetadata) : void       
    {
    	var oldValue : _DataEntityMetadata = model_internal::_dminternal_model;               
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
