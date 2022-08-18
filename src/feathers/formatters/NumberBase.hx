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
	The NumberBase class is a utility class that contains
	general number formatting capabilities, including rounding,
	precision, thousands formatting, and negative sign formatting.
	The implementation of the formatter classes use this class.

	@see `feathers.formatters.NumberFormatter`
	@see `feathers.formatters.NumberBaseRoundType`
**/
class NumberBase {
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.
		 
		@param decimalSeparatorFrom Decimal separator to use
		when parsing an input String.

		@param thousandsSeparatorFrom Character to use
		as the thousands separator in the input String.

		@param decimalSeparatorTo Decimal separator character to use
		when outputting formatted decimal numbers.

		@param thousandsSeparatorTo Character to use
		as the thousands separator in the output String.
	**/
	public function new(decimalSeparatorFrom:String = ".", thousandsSeparatorFrom:String = ",", decimalSeparatorTo:String = ".",
			thousandsSeparatorTo:String = ",") {
		this.decimalSeparatorFrom = decimalSeparatorFrom;
		this.thousandsSeparatorFrom = thousandsSeparatorFrom;
		this.decimalSeparatorTo = decimalSeparatorTo;
		this.thousandsSeparatorTo = thousandsSeparatorTo;

		isValid = true;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
	//  decimalSeparatorFrom
	//----------------------------------

	/**
		Decimal separator character to use
		when parsing an input String.

		@default "."
	**/
	public var decimalSeparatorFrom:String;

	//----------------------------------
	//  decimalSeparatorTo
	//----------------------------------

	/**
		Decimal separator character to use
		when outputting formatted decimal numbers.

		@default "."
	**/
	public var decimalSeparatorTo:String;

	//----------------------------------
	//  isValid
	//----------------------------------

	/**
		If `true`, the format succeeded,
		otherwise it is `false`.
	**/
	public var isValid:Bool = false;

	//----------------------------------
	//  thousandsSeparatorFrom
	//----------------------------------

	/**
		Character to use as the thousands separator
		in the input String.

		@default ","
	**/
	public var thousandsSeparatorFrom:String;

	//----------------------------------
	//  thousandsSeparatorTo
	//----------------------------------

	/**
		Character to use as the thousands separator
		in the output String.

		@default ","
	**/
	public var thousandsSeparatorTo:String;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
		Formats a number by rounding it. 
		The possible rounding types are defined by
		feathers.formatters.NumberBaseRoundType.

		@param value Value to be rounded.

		@param roundType The type of rounding to perform:
		NumberBaseRoundType.NONE, NumberBaseRoundType.UP,
		NumberBaseRoundType.DOWN, or NumberBaseRoundType.NEAREST.

		@return Formatted number.

		@see `feathers.formatters.NumberBaseRoundType`
	**/
	public function formatRounding(value:String, roundType:String):String {
		var v:Float = Std.parseFloat(value);

		if (roundType != NumberBaseRoundType.NONE) {
			if (roundType == NumberBaseRoundType.UP) {
				v = Math.ceil(v);
			} else if (roundType == NumberBaseRoundType.DOWN) {
				v = Math.floor(v);
			} else if (roundType == NumberBaseRoundType.NEAREST) {
				v = Math.round(v);
			} else {
				isValid = false;
				return "";
			}
		}

		return Std.string(v);
	}

	/**
		Formats a number by rounding it and setting the decimal precision.
		The possible rounding types are defined by
		feathers.formatters.NumberBaseRoundType.

		@param value Value to be rounded.

		@param roundType The type of rounding to perform:
		NumberBaseRoundType.NONE, NumberBaseRoundType.UP,
		NumberBaseRoundType.DOWN, or NumberBaseRoundType.NEAREST.

		@param precision int of decimal places to use.

		@return Formatted number.

		@see `feathers.formatters.NumberBaseRoundType`
	**/
	public function formatRoundingWithPrecision(value:String, roundType:String, precision:Int):String {
		// precision works differently now. Its default value is -1
		// which means 'do not alter the number's precision'. If a precision
		// value is set, all numbers will contain that precision. Otherwise, there
		// precision will not be changed.

		var v:Float = Std.parseFloat(value);

		// If rounding is not present and precision is NaN,
		// leave value untouched.
		if (roundType == NumberBaseRoundType.NONE) {
			if (precision == -1) {
				return Std.string(v);
			}
		} else {
			// If rounding is present but precision is less than 0,
			// then do integer rounding.
			if (precision < 0) {
				precision = 0;
			}

			// Shift decimal right as Math functions
			// perform only integer ceil/round/floor.
			v = v * Math.pow(10, precision);

			// Attempt to get rid of floating point errors
			v = Std.parseFloat(Std.string(v));
			if (roundType == NumberBaseRoundType.UP) {
				v = Math.fceil(v);
			} else if (roundType == NumberBaseRoundType.DOWN) {
				v = Math.ffloor(v);
			} else if (roundType == NumberBaseRoundType.NEAREST) {
				v = Math.fround(v);
			} else {
				isValid = false;
				return "";
			}

			// Shift decimal left to get back decimal to original point.
			v = v / Math.pow(10, precision);
		}

		return Std.string(v);
	}

	/**
		Formats a number by replacing the default decimal separator, ".", 
		with the decimal separator specified by `decimalSeparatorTo`. 

		@param value The String value of the Number
		(formatted American style ####.##).

		@return String representation of the input where "." is replaced
		with the decimal formatting character.
	**/
	public function formatDecimal(value:String):String {
		var parts:Array<String> = value.split(".");
		return parts.join(decimalSeparatorTo);
	}

	/**
		Formats a number by using 
		the `thousandsSeparatorTo` property as the thousands separator 
		and the `decimalSeparatorTo` property as the decimal separator.

		@param value Value to be formatted.

		@return Formatted number.
	**/
	public function formatThousands(value:String):String {
		var v:Float = Std.parseFloat(value);

		var isNegative:Bool = (v < 0);

		var numStr:String = Std.string(Math.abs(v));

		numStr = numStr.toLowerCase();
		var e:Int = numStr.indexOf("e");
		if (e != -1) // deal with exponents
		{
			numStr = expandExponents(numStr);
		}

		var numArr:Array<String> = numStr.split((numStr.indexOf(decimalSeparatorTo) != -1) ? decimalSeparatorTo : ".");
		var numLen:Int = Std.string(numArr[0]).length;

		if (numLen > 3) {
			var numSep:Int = Math.floor(numLen / 3);

			if ((numLen % 3) == 0) {
				numSep--;
			}

			var b:Int = numLen;
			var a:Int = b - 3;

			var arr:Array<String> = [];
			for (i in 0...(numSep + 1)) {
				arr[i] = numArr[0].substring(a, b);
				a = Std.int(Math.max(a - 3, 0));
				b = Std.int(Math.max(b - 3, 1));
			}

			arr.reverse();

			numArr[0] = arr.join(thousandsSeparatorTo);
		}

		numStr = numArr.join(decimalSeparatorTo);

		if (isNegative) {
			numStr = "-" + numStr;
		}

		return numStr;
	}

	/**
		Formats a number by setting its decimal precision by using 
		the `decimalSeparatorTo` property as the decimal separator.

		@param value Value to be formatted.

		@param precision Number of decimal points to use.

		@return Formatted number.
	**/
	public function formatPrecision(value:String, precision:Int):String {
		// precision works differently now. Its default value is -1
		// which stands for 'do not alter the number's precision'. If a precision
		// value is set, all numbers will contain that precision. Otherwise, there
		// precision will not be changed.

		if (precision == -1) {
			return value;
		}

		var numArr:Array<String> = value.split(decimalSeparatorTo);

		numArr[0] = (numArr[0].length == 0) ? "0" : numArr[0];

		if (precision > 0) {
			var decimalVal:String = (numArr[1] != null) ? numArr[1] : "";
			var fraction:String = decimalVal + "000000000000000000000000000000000";
			value = numArr[0] + decimalSeparatorTo + fraction.substr(0, precision);
		} else {
			value = numArr[0];
		}

		return value;
	}

	/**
		Formats a negative number with either a minus sign (-)
		or parentheses ().

		@param value Value to be formatted.

		@param useSign If `true`, use a minus sign (-).
		If `false`, use parentheses ().

		@return Formatted number.
	**/
	public function formatNegative(value:String, useSign:Bool):String {
		if (useSign) {
			if (value.charAt(0) != "-") {
				value = "-" + value;
			}
		} else if (!useSign) {
			if (value.charAt(0) == "-") {
				value = value.substr(1, value.length - 1);
			}
			value = "(" + value + ")";
		} else {
			isValid = false;
			return "";
		}
		return value;
	}

	/**
		Extracts a number from a formatted String.
		Examines the String from left to right
		and returns the first number sequence.
		Ignores thousands separators and includes the
		decimal and numbers trailing the decimal.

		@param str String to parse for the numeric value.

		@return Value, which can be a decimal.
	**/
	public function parseNumberString(str:String):String {
		// Check the decimal and thousands formatting for validity.
		var splitDec:Array<String> = str.split(decimalSeparatorFrom);
		if (splitDec.length > 2) {
			return null;
		}

		// Attempt to extract the first number sequence from the string.
		var len:Int = str.length;
		var count:Int = 0;
		var letter:String;
		var num:String = null;
		var isNegative:Bool = false;
		var hasExponent:Bool = false;

		while (count < len) {
			letter = str.charAt(count);
			count++;

			if (("0" <= letter && letter <= "9") || (letter == decimalSeparatorFrom)) {
				var lastLetter:String = str.charAt(count - 2);
				// We must handle cases where we have negative input like "-YTL5.000,00"
				// and currencySymbol is longer than one character.
				if ((lastLetter == "-") || (str.charAt(0) == "-")) {
					isNegative = true;
				}
				num = "";
				count--;

				for (i in count...len) {
					letter = str.charAt(count);
					count++;
					if ("0" <= letter && letter <= "9") {
						num += letter;
					} else if (letter == decimalSeparatorFrom) {
						num += ".";
					} else if (letter == "e" || letter == "E") {
						num += letter;
						hasExponent = true;
					} else if (hasExponent && (letter == "-" || letter == "+")) {
						num += letter;
					} else if (letter != thousandsSeparatorFrom || count >= len) {
						break;
					}
				}
			}
		}

		// there are all sorts of variations of zero, such as:
		// .0    0.   0.0    0000     0000.00000     -0
		// Here, we simply convert to a 'real' Number and see if
		// it's resolved to zero. if it does, just return a zero
		// string and be done with it.
		if ((num != null) && (str != '')) {
			var n:Float = Std.parseFloat(num);

			if (n == 0) {
				return '0';
			}
		}

		// if the last digit is the dot, whack it
		if (num != null && num.length > 0) {
			if (num.charAt(num.length - 1) == '.') {
				// we have something like 33.
				if (num.length >= 2) {
					num = num.substring(0, num.length - 1);
				}
				// we have merely .
				else if (num.length == 1) {
					num = '';
					isNegative = false;
				}
			}
		}

		return isNegative ? "-" + num : num;
	}

	/**
		Formats a number in exponent notation, into 
		a number in decimal notation.

		@param str String to process in exponent notation.

		@return Formatted number.
	**/
	public function expandExponents(value:String):String {
		// Break string into component parts
		var regExp = ~/^([+-])?(\d+).?(\d*)[eE]([-+]?\d+)$/;
		var sign:String = null;
		var first:String = null;
		var last:String = null;
		var exp:Int = 0;
		if (regExp.match(value)) {
			sign = regExp.matched(1);
			first = regExp.matched(2);
			last = regExp.matched(3);
			exp = Std.parseInt(regExp.matched(4));
		}

		// if we didn't get a good exponent to begin with, return what we can figure out
		if (exp == 0) {
			return (sign != null ? sign : "") + (first != null ? first : "0") + (last != null ? "." + last : "");
		}

		var r:String = first + last;

		var decimal:Bool = exp < 0;

		if (decimal) {
			var o:Int = -1 * (first.length + exp) + 1;
			return (sign != null ? sign : "") + "0." + StringTools.rpad("", "0", o) + r;
		} else {
			var i:Int = exp + first.length;
			if (i >= r.length)
				return (sign != null ? sign : "") + r + StringTools.rpad("", "0", i - r.length + 1);
			else
				return (sign != null ? sign : "") + r.substr(0, i) + "." + r.substr(i);
		}
	}
}
