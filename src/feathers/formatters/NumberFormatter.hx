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
	The NumberFormatter class formats a valid number
	by adjusting the decimal rounding and precision,
	the thousands separator, and the negative sign.

	If you use both the `rounding` and `precision`
	properties, rounding is applied first, and then you set the decimal length
	by using the specified `precision` value.
	This lets you round a number and still have a trailing decimal;
	for example, 303.99 = 304.00.

	If an error occurs, an empty String is returned and a String
	describing  the error is saved to the `error` property.
	The `error`  property can have one of the following values:

	- `"Invalid value"` means an invalid numeric value is passed to 
	the `format()` method. The value should be a valid number in the 
	form of a Number or a String.
	- `"Invalid format"` means one of the parameters
	contain an unusable setting.

	@see `feathers.formatters.NumberBase`
	@see `feathers.formatters.NumberBaseRoundType`
**/
class NumberFormatter extends Formatter {
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
	//  decimalSeparatorFrom
	//----------------------------------
	private var _decimalSeparatorFrom:String;

	private var decimalSeparatorFromOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Decimal separator character to use
		when parsing an input String.

		When setting this property, ensure that the value of the 
		`thousandsSeparatorFrom` property does not equal this property. 
		Otherwise, an error occurs when formatting the value.

		@default "."
	**/
	public var decimalSeparatorFrom(get, set):String;

	private function get_decimalSeparatorFrom():String {
		return _decimalSeparatorFrom;
	}

	private function set_decimalSeparatorFrom(value:String):String {
		decimalSeparatorFromOverride = value;

		_decimalSeparatorFrom = value != null ? value : ".";
		return _decimalSeparatorFrom;
	}

	//----------------------------------
	//  decimalSeparatorTo
	//----------------------------------
	private var _decimalSeparatorTo:String;

	private var decimalSeparatorToOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Decimal separator character to use
		when outputting formatted decimal numbers.

		When setting this property, ensure that the value of the  
		`thousandsSeparatorTo` property does not equal this property. 
		Otherwise, an error occurs when formatting the value.

		@default "."
	**/
	public var decimalSeparatorTo(get, set):String;

	private function get_decimalSeparatorTo():String {
		return _decimalSeparatorTo;
	}

	private function set_decimalSeparatorTo(value:String):String {
		decimalSeparatorToOverride = value;

		_decimalSeparatorTo = value != null ? value : ".";
		return _decimalSeparatorTo;
	}

	//----------------------------------
	//  precision
	//----------------------------------
	private var _precision:Int;

	private var precisionOverride:Int = -1;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Number of decimal places to include in the output String.
		You can disable precision by setting it to `-1`.
		A value of `-1` means do not change the precision. For example, 
		if the input value is 1.453 and `rounding` 
		is set to `NumberBaseRoundType.NONE`, return a value of 1.453.
		If `precision` is `-1` and you have set some form of 
		rounding, return a value based on that rounding type.

		@default -1
	**/
	public var precision(get, set):Int;

	private function get_precision():Int {
		return _precision;
	}

	private function set_precision(value:Int):Int {
		precisionOverride = value;

		_precision = value;
		return _precision;
	}

	//----------------------------------
	//  rounding
	//----------------------------------
	private var _rounding:String;

	private var roundingOverride:String;

	// [Inspectable(category="General", enumeration="none,up,down,nearest", defaultValue="null")]

	/**
		Specifies how to round the number.

		In Haxe, you can use the following constants to set this property: 

		- `NumberBaseRoundType.NONE`
		- `NumberBaseRoundType.UP`
		- `NumberBaseRoundType.DOWN`
		- `NumberBaseRoundType.NEAREST`

		@default NumberBaseRoundType.NONE

		@see `feathers.formatters.NumberBaseRoundType`
	**/
	public var rounding(get, set):String;

	private function get_rounding():String {
		return _rounding;
	}

	private function set_rounding(value:String):String {
		roundingOverride = value;

		_rounding = value != null ? value : NumberBaseRoundType.NONE;
		return _rounding;
	}

	//----------------------------------
	//  thousandsSeparatorFrom
	//----------------------------------
	private var _thousandsSeparatorFrom:String;

	private var thousandsSeparatorFromOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Character to use as the thousands separator
		in the input String.

		When setting this property, ensure that the value of the
		`decimalSeparatorFrom` property does not equal this property. 
		Otherwise, an error occurs when formatting the value.

		@default ","
	**/
	public var thousandsSeparatorFrom(get, set):String;

	private function get_thousandsSeparatorFrom():String {
		return _thousandsSeparatorFrom;
	}

	private function set_thousandsSeparatorFrom(value:String):String {
		thousandsSeparatorFromOverride = value;

		_thousandsSeparatorFrom = value != null ? value : ",";
		return _thousandsSeparatorFrom;
	}

	//----------------------------------
	//  thousandsSeparatorTo
	//----------------------------------
	private var _thousandsSeparatorTo:String;

	private var thousandsSeparatorToOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Character to use as the thousands separator
		in the output String.

		When setting this property, ensure that the value of the  
		`decimalSeparatorTo` property does not equal this property. 
		Otherwise, an error occurs when formatting the value.

		@default ","
	**/
	public var thousandsSeparatorTo(get, set):String;

	private function get_thousandsSeparatorTo():String {
		return _thousandsSeparatorTo;
	}

	private function set_thousandsSeparatorTo(value:String):String {
		thousandsSeparatorToOverride = value;

		_thousandsSeparatorTo = value != null ? value : ",";
		return _thousandsSeparatorTo;
	}

	//----------------------------------
	//  useNegativeSign
	//----------------------------------
	private var _useNegativeSign:Bool;

	private var useNegativeSignOverride:Bool = true;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		If `true`, format a negative number 
		by preceding it with a minus "-" sign.
		If `false`, format the number
		surrounded by parentheses, for example (400).

		@default true
	**/
	public var useNegativeSign(get, set):Bool;

	private function get_useNegativeSign():Bool {
		return _useNegativeSign;
	}

	private function set_useNegativeSign(value:Bool):Bool {
		useNegativeSignOverride = value;

		_useNegativeSign = value;
		return _useNegativeSign;
	}

	//----------------------------------
	//  useThousandsSeparator
	//----------------------------------
	private var _useThousandsSeparator:Bool;

	private var useThousandsSeparatorOverride:Bool = true;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		If `true`, split the number into thousands increments
		by using a separator character.

		@default true
	**/
	public var useThousandsSeparator(get, set):Bool;

	private function get_useThousandsSeparator():Bool {
		return _useThousandsSeparator;
	}

	private function set_useThousandsSeparator(value:Bool):Bool {
		useThousandsSeparatorOverride = value;

		_useThousandsSeparator = value;
		return _useThousandsSeparator;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override private function resourcesChanged():Void {
		super.resourcesChanged();

		decimalSeparatorFrom = decimalSeparatorFromOverride;
		decimalSeparatorTo = decimalSeparatorToOverride;
		precision = precisionOverride;
		rounding = roundingOverride;
		thousandsSeparatorFrom = thousandsSeparatorFromOverride;
		thousandsSeparatorTo = thousandsSeparatorToOverride;
		useNegativeSign = useNegativeSignOverride;
		useThousandsSeparator = useThousandsSeparatorOverride;
	}

	/**
		Formats the number as a String.
		If `value` cannot be formatted, return an empty String 
		and write a description of the error to the `error` property.

		@param value Value to format.

		@return Formatted String. Empty if an error occurs.
	**/
	override public function format(value:Dynamic):String {
		// Reset any previous errors.
		if (error != null) {
			error = null;
		}

		if (useThousandsSeparator && ((decimalSeparatorFrom == thousandsSeparatorFrom) || (decimalSeparatorTo == thousandsSeparatorTo))) {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		if (decimalSeparatorTo == "" || !Math.isNaN(Std.parseFloat(decimalSeparatorTo))) {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		var dataFormatter:NumberBase = new NumberBase(decimalSeparatorFrom, thousandsSeparatorFrom, decimalSeparatorTo, thousandsSeparatorTo);

		// -- value --

		if ((value is String)) {
			value = dataFormatter.parseNumberString((value : String));
		}

		if (value == null || Math.isNaN(Std.parseFloat(Std.string(value)))) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// -- format --

		var numStr:String = Std.string(value);

		var isNegative:Bool = (Std.parseFloat(numStr) < 0);

		numStr = numStr.toLowerCase();
		var e:Int = numStr.indexOf("e");
		if (e != -1) // deal with exponents
		{
			numStr = dataFormatter.expandExponents(numStr);
		}

		var numArrTemp:Array<String> = numStr.split(".");
		var numFraction:Int = numArrTemp[1] != null ? Std.string(numArrTemp[1]).length : 0;

		if (precision < numFraction) {
			if (rounding != NumberBaseRoundType.NONE) {
				numStr = dataFormatter.formatRoundingWithPrecision(numStr, rounding, precision);
			}
		}

		var numValue:Float = Std.parseFloat(numStr);
		if (Math.abs(numValue) >= 1) {
			numArrTemp = numStr.split(".");
			var front:String = useThousandsSeparator ? dataFormatter.formatThousands(numArrTemp[0]) : numArrTemp[0];
			if (numArrTemp[1] != null && numArrTemp[1] != "") {
				numStr = front + decimalSeparatorTo + numArrTemp[1];
			} else {
				numStr = front;
			}
		} else if (Math.abs(numValue) > 0) {
			// Check if the string is in scientific notation
			numStr = numStr.toLowerCase();
			if (numStr.indexOf("e") != -1) {
				var temp:Float = Math.abs(numValue) + 1;
				numStr = Std.string(temp);
			}
			numStr = decimalSeparatorTo + numStr.substring(numStr.indexOf(".") + 1);
		}

		numStr = dataFormatter.formatPrecision(numStr, precision);

		// If our value is 0, then don't show -0
		if (Std.parseFloat(numStr) == 0) {
			isNegative = false;
		}

		if (isNegative) {
			numStr = dataFormatter.formatNegative(numStr, useNegativeSign);
		}

		if (!dataFormatter.isValid) {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		return numStr;
	}
}
