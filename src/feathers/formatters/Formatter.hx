/*
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF licenses this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package feathers.formatters;

/**
	The Formatter class is the base class for all data formatters.
	Any subclass of Formatter must override the `format()` method.
**/
class Formatter implements IFormatter {
	private static final DEFAULT_INVALID_FORMAT_ERROR = "Invalid format";
	private static final DEFAULT_INVALID_VALUE_ERROR = "Invalid value";

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	private static var initialized:Bool = false;

	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  defaultInvalidFormatError
	//----------------------------------
	private static var _defaultInvalidFormatError:String;

	private static var defaultInvalidFormatErrorOverride:String;

	/**
		Error message for an invalid format string specified to the formatter.
		The localeChain property of the ResourceManager is used to resolve
		the default error message. If it is unable to find a value, it will
		return `null`. This can happen if none of the locales
		specified in the localeChain are compiled into the application.

		@default "Invalid format"
	**/
	public static var defaultInvalidFormatError(get, set):String;

	private static function get_defaultInvalidFormatError():String {
		initialize();

		return _defaultInvalidFormatError;
	}

	private static function set_defaultInvalidFormatError(value:String):String {
		defaultInvalidFormatErrorOverride = value;

		_defaultInvalidFormatError = value != null ? value : DEFAULT_INVALID_FORMAT_ERROR;
		return _defaultInvalidFormatError;
	}

	//----------------------------------
	//  defaultInvalidValueError
	//----------------------------------
	private static var _defaultInvalidValueError:String;

	private static var defaultInvalidValueErrorOverride:String;

	/**
		Error messages for an invalid value specified to the formatter. The
		localeChain property of the ResourceManager is used to resolve the
		default error message. If it is unable to find a value, it will return
		`null`. This can happen if none of the locales specified in
		the localeChain are compiled into the application.

		@default "Invalid value"
	**/
	public static var defaultInvalidValueError(get, set):String;

	private static function get_defaultInvalidValueError():String {
		initialize();

		return _defaultInvalidValueError;
	}

	private static function set_defaultInvalidValueError(value:String):String {
		defaultInvalidValueErrorOverride = value;

		_defaultInvalidValueError = value != null ? value : DEFAULT_INVALID_VALUE_ERROR;
		return _defaultInvalidValueError;
	}

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	private static function initialize():Void {
		if (!initialized) {
			static_resourcesChanged();

			initialized = true;
		}
	}

	private static function static_resourcesChanged():Void {
		defaultInvalidFormatError = defaultInvalidFormatErrorOverride;
		defaultInvalidValueError = defaultInvalidValueErrorOverride;
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.
	**/
	public function new() {
		resourcesChanged();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  error
	//----------------------------------
	// [Inspectable(category="General", defaultValue="null")]

	/**
		Description saved by the formatter when an error occurs.
		For the possible values of this property,
		see the description of each formatter.

		Subclasses must set this value in the `format()` method.
	**/
	public var error:String;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
		This method is called when a Formatter is constructed,
		and again whenever the ResourceManager dispatches
		a `"change"` Event to indicate
		that the localized resources have changed in some way.

		This event will be dispatched when you set the ResourceManager's
		`localeChain` property, when a resource module
		has finished loading, and when you call the ResourceManager's
		`update()` method.

		Subclasses should override this method and, after calling
		`super.resourcesChanged()`, do whatever is appropriate
		in response to having new resource values.
	**/
	private function resourcesChanged():Void {}

	/**
		Formats a value and returns a String
		containing the new, formatted, value.
		All subclasses must override this method to implement the formatter.

		@param value Value to be formatted.

		@return The formatted string.
	**/
	public function format(value:Dynamic):String {
		error = "This format function is abstract. " + "Subclasses must override it.";

		return "";
	}
}
