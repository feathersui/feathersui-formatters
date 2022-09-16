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
	The CurrencyFormatter class formats a valid number as a currency value.
	It adjusts the decimal rounding and precision, the thousands separator, 
	and the negative sign; it also adds a currency symbol.
	You place the currency symbol on either the left or the right side
	of the value with the `alignSymbol` property.
	The currency symbol can contain multiple characters,
	including blank spaces.

	If an error occurs, an empty String is returned and a String that describes 
	the error is saved to the `error` property. The `error` 
	property can have one of the following values:

	- `"Invalid value"` means an invalid numeric value is passed to 
	the `format()` method. The value should be a valid number in the 
	form of a Number or a String.
	- `"Invalid format"` means one of the parameters contains an unusable setting.

	@see `feathers.formatters.NumberBase`
	@see `feathers.formatters.NumberBaseRoundType`
**/
class CurrencyFormatter extends Formatter {
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.
	 */
	public function new() {
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  alignSymbol
	//----------------------------------
	private var _alignSymbol:String;

	private var alignSymbolOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Aligns currency symbol to the left side or the right side
		of the formatted number.
		Permitted values are `"left"` and `"right"`.

		@default feathers.formatters.CurrencyFormatterAlignSymbol.LEFT

		@see `feathers.formatters.CurrencyFormatterAlignSymbol`
	**/
	public var alignSymbol(get, set):String;

	private function get_alignSymbol():String {
		return _alignSymbol;
	}

	private function set_alignSymbol(value:String):String {
		alignSymbolOverride = value;

		_alignSymbol = value != null ? value : CurrencyFormatterAlignSymbol.LEFT;
		return _alignSymbol;
	}

	//----------------------------------
	//  currencySymbol
	//----------------------------------
	private var _currencySymbol:String;

	private var currencySymbolOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Character to use as a currency symbol for a formatted number.
		You can use one or more characters to represent the currency 
		symbol; for example, "$" or "YEN".
		You can also use empty spaces to add space between the 
		currency character and the formatted number.
		When the number is a negative value, the currency symbol
		appears between the number and the minus sign or parentheses.

		@default "$"
	**/
	public var currencySymbol(get, set):String;

	private function get_currencySymbol():String {
		return _currencySymbol;
	}

	private function set_currencySymbol(value:String):String {
		currencySymbolOverride = value;

		_currencySymbol = value != null ? value : "$";
		return _currencySymbol;
	}

	//----------------------------------
	//  decimalSeparatorFrom
	//----------------------------------
	private var _decimalSeparatorFrom:String;

	private var decimalSeparatorFromOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
		Decimal separator character to use
		when parsing an input string.

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
		is set to `NumberBaseRoundType.NONE`, return 1.453.
		If `precision` is -1 and you set some form of 
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

		- `NumberBaseRoundType.NONE`,
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
		in the output string.

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

		alignSymbol = alignSymbolOverride;
		currencySymbol = currencySymbolOverride;
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
		Formats `value` as currency.
		If `value` cannot be formatted, return an empty String 
		and write a description of the error to the `error` property.

		@param value Value to format.

		@return Formatted string. Empty if an error occurs.
	**/
	override public function format(value:Dynamic):String {
		// Reset any previous errors.
		if (error != null) {
			error = null;
		}

		if (useThousandsSeparator && (decimalSeparatorFrom == thousandsSeparatorFrom || decimalSeparatorTo == thousandsSeparatorTo)) {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		if (decimalSeparatorTo == "") {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		var dataFormatter:NumberBase = new NumberBase(decimalSeparatorFrom, thousandsSeparatorFrom, decimalSeparatorTo, thousandsSeparatorTo);

		// -- value --

		if ((value is String)) {
			var temp_value:String = dataFormatter.parseNumberString(Std.string(value));

			// If we got 0 back, but string was longer than one character, NumberBase
			// Chopped our value.  So we need to do some formatting to get our value back
			// to the way it was.
			if (temp_value == "0") {
				var valueArr:Array<String> = value.split(decimalSeparatorFrom);
				value = valueArr[0];
				if (valueArr[1] != null) {
					value += "." + valueArr[1];
				} else {
					value = temp_value;
				}
			} else {
				value = temp_value;
			}
		}

		if (value == null || Math.isNaN(Std.parseFloat(value))) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// -- format --

		var numStr:String = Std.string(value);

		var isNegative:Bool = (Std.parseFloat(numStr) < 0);

		var numArrTemp:Array<String> = numStr.split(".");
		var numFraction:Int = numArrTemp[1] != null ? Std.string(numArrTemp[1]).length : 0;

		if (precision <= numFraction) {
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
		} else if (Math.abs(numValue) >= 0) {
			// if the value is in scientefic notation then the search for '.'
			// doesnot give the correct result. Adding one to the value forces
			// the value to normal decimal notation.
			// As we are dealing with only the decimal portion we need not
			// worry about reverting the addition
			if (numStr.indexOf("e") != -1) {
				var temp:Float = Math.abs(numValue) + 1;
				numStr = Std.string(temp);
			}

			// Handle leading zero if we got one give one if not don't
			var position:Int = numStr.indexOf(".");
			var leading:String = position > 0 ? "0" : "";

			// must be zero ("0") if no "." and >= 0 and < 1
			if (position != -1) {
				numStr = leading + decimalSeparatorTo + numStr.substring(position + 1);
			}
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

		// -- currency --

		if (alignSymbol == "left") {
			if (isNegative) {
				var nSign:String = numStr.charAt(0);
				var baseVal:String = numStr.substr(1, numStr.length - 1);
				numStr = nSign + currencySymbol + baseVal;
			} else {
				numStr = currencySymbol + numStr;
			}
		} else if (alignSymbol == "right") {
			var lastChar:String = numStr.charAt(numStr.length - 1);
			if (isNegative && lastChar == ")") {
				var baseVal:String = numStr.substr(0, numStr.length - 1);
				numStr = baseVal + currencySymbol + lastChar;
			} else {
				numStr = numStr + currencySymbol;
			}
		} else {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		return numStr;
	}
}
