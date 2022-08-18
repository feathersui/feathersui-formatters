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
	The ZipCodeFormatter class formats a valid number
	into one of the following formats, based on a
	user-supplied `formatString` property.

	- #####-####
	- ##### ####
	- #####
	- ### ### (Canadian)

	A six-digit number must be supplied for a six-digit mask.
	If you use a five-digit or a nine-digit mask, you can use
	either a five-digit or a nine-digit number for formatting.

	If an error occurs, an empty String is returned and a String that  
	describes the error is saved to the `error` property.  
	The `error` property can have one of the following values:

	- `"Invalid value"` means an invalid numeric value is passed 
	to the `format()` method. The value should be a valid number 
	in the form of a Number or a String, except for Canadian postal code, 
	which allows alphanumeric values, or the number of digits does not match 
	the allowed digits from the `formatString` property.
	- `"Invalid format"` means any of the characters in the 
	`formatString` property do not match the allowed characters 
	specified in the `validFormatChars` property, 
	or the number of numeric placeholders does not equal 9, 5, or 6.

	@see `feathers.formatters.SwitchSymbolFormatter`
**/
class ZipCodeFormatter extends Formatter {
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	private static final VALID_LENGTHS:String = "9,5,6";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.
	**/
	public function new() {
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  formatString
	//----------------------------------
	private var _formatString:String;

	private var formatStringOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		The mask pattern.
		Possible values are `"#####-####"`,
		`"##### ####"`, `"#####"`,
		`"###-###"` and `"### ###"`.
			 
		@default "#####"
	**/
	public var formatString(get, set):String;

	private function get_formatString():String {
		return _formatString;
	}

	private function set_formatString(value:String):String {
		formatStringOverride = value;

		_formatString = value != null ? value : "#####";
		return _formatString;
	}

	//--------------------------------------------------------------------------
	//
	//  Overidden methods
	//
	//--------------------------------------------------------------------------

	override private function resourcesChanged():Void {
		super.resourcesChanged();

		formatString = formatStringOverride;
	}

	/**
		Formats the String by using the specified format.
		If the value cannot be formatted, return an empty String 
		and write a description of the error to the `error` property.

		@param value Value to format.

		@return Formatted String. Empty if an error occurs. A description 
		of the error condition is written to the `error` property.
	**/
	override public function format(value:Dynamic):String {
		// Reset any previous errors.
		if (error != null) {
			error = null;
		}

		// -- lengths --

		var fStrLen:Int;
		var uStrLen:Int = Std.string(value).length;

		if (VALID_LENGTHS.indexOf("" + uStrLen) == -1) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		if (formatString == "#####-####" || formatString == "##### ####") {
			if (uStrLen != 5 && uStrLen != 9) {
				error = Formatter.defaultInvalidValueError;
				return "";
			}
			fStrLen = 9;
		} else if (formatString == "#####") {
			if (uStrLen != 5 && uStrLen != 9) {
				error = Formatter.defaultInvalidValueError;
				return "";
			}
			fStrLen = 5;
		} else if (formatString == "### ###" || formatString == "###-###") {
			if (uStrLen != 6) {
				error = Formatter.defaultInvalidValueError;
				return "";
			}
			fStrLen = 6;
		} else {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		if (fStrLen == 6 && uStrLen != 6) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// -- value --

		if (fStrLen == 6) {
			for (i in 0...uStrLen) {
				if ((value.charCodeAt(i) < 64 || value.charCodeAt(i) > 90) && (value.charCodeAt(i) < 48 || value.charCodeAt(i) > 57)) {
					error = Formatter.defaultInvalidValueError;
					return "";
				}
			}
		} else {
			if (value == null || Math.isNaN(Std.parseFloat(Std.string(value)))) {
				error = Formatter.defaultInvalidValueError;
				return "";
			}
		}

		// --format--

		if (fStrLen == 9 && uStrLen == 5) {
			value = Std.string(value) + "0000";
		}

		if (fStrLen == 5 && uStrLen == 9) {
			value = value.substr(0, 5);
		}

		var dataFormatter:SwitchSymbolFormatter = new SwitchSymbolFormatter();

		return dataFormatter.formatValue(formatString, value);
	}
}
