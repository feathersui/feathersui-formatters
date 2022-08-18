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
 *  The PhoneFormatter class formats a valid number into a phone number format,
 *  including international configurations.
 *
 *  <p>A shortcut is provided for the United States seven-digit format.
 *  If the <code>areaCode</code> property contains a value
 *  and you use the seven-digit format string, (###-####),
 *  a seven-digit value to format automatically adds the area code
 *  to the returned String.
 *  The default format for the area code is (###). 
 *  You can change this using the <code>areaCodeFormat</code> property. 
 *  You can format the area code any way you want as long as it contains 
 *  three number placeholders.</p>
 *
 *  <p>If an error occurs, an empty String is returned and a String
 *  that describes the error is saved to the <code>error</code> property.
 *  The <code>error</code> property can have one of the following values:</p>
 *
 *  <ul>
 *    <li><code>"Invalid value"</code> means an invalid numeric value is passed 
 *    to the <code>format()</code> method. The value should be a valid number 
 *    in the form of a Number or a String, or the value contains a different 
 *    number of digits than what is specified in the format String.</li>
 *    <li> <code>"Invalid format"</code> means any of the characters in the 
 *    <code>formatString</code> property do not match the allowed characters 
 *    specified in the <code>validPatternChars</code> property, 
 *    or the <code>areaCodeFormat</code> property is specified but does not
 *    contain exactly three numeric placeholders.</li>
 *  </ul>
 *  
 *  @see `feathers.formatters.SwitchSymbolFormatter`
 */
class PhoneFormatter extends Formatter {
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
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
	//  areaCode
	//----------------------------------
	private var _areaCode:Dynamic;

	private var areaCodeOverride:Dynamic;

	// [Inspectable(category="General", defaultValue="null")]

	/**
	 *  Area code number added to a seven-digit United States
	 *  format phone number to form a 10-digit phone number.
	 *  A value of <code>-1</code> means do not  
	 *  prepend the area code.
	 *
	 *  @default -1
	 */
	public var areaCode(get, set):Dynamic;

	private function get_areaCode():Dynamic {
		return _areaCode;
	}

	private function set_areaCode(value:Dynamic):Dynamic {
		areaCodeOverride = value;

		_areaCode = value != null ? Std.parseInt(Std.string(value)) : -1;
		return _areaCode;
	}

	//----------------------------------
	//  areaCodeFormat
	//----------------------------------
	private var _areaCodeFormat:String;

	private var areaCodeFormatOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
	 *  Default format for the area code when the <code>areacode</code>
	 *  property is rendered by a seven-digit format.
	 *
	 *  @default "(###) "
	 */
	public var areaCodeFormat(get, set):String;

	private function get_areaCodeFormat():String {
		return _areaCodeFormat;
	}

	private function set_areaCodeFormat(value:String):String {
		areaCodeFormatOverride = value;

		_areaCodeFormat = value != null ? value : "(###)";
		return _areaCodeFormat;
	}

	//----------------------------------
	//  formatString
	//----------------------------------
	private var _formatString:String;

	private var formatStringOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
	 *  String that contains mask characters
	 *  that represent a specified phone number format.
	 *
	 *  @default "(###) ###-####"
	 */
	public var formatString(get, set):String;

	private function get_formatString():String {
		return _formatString;
	}

	private function set_formatString(value:String):String {
		formatStringOverride = value;

		_formatString = value != null ? value : "(###) ###-####";
		return _formatString;
	}

	//----------------------------------
	//  validPatternChars
	//----------------------------------
	private var _validPatternChars:String;

	private var validPatternCharsOverride:String;

	// [Inspectable(category="General", defaultValue="null")]

	/**
	 *  List of valid characters that can be used
	 *  in the <code>formatString</code> property.
	 *  This property is used during validation
	 *  of the <code>formatString</code> property.
	 *
	 *  @default "+()#- ."
	 */
	public var validPatternChars(get, set):String;

	private function get_validPatternChars():String {
		return _validPatternChars;
	}

	private function set_validPatternChars(value:String):String {
		validPatternCharsOverride = value;

		_validPatternChars = value != null ? value : "+()#- .";
		return _validPatternChars;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override private function resourcesChanged():Void {
		super.resourcesChanged();

		areaCode = areaCodeOverride;
		areaCodeFormat = areaCodeFormatOverride;
		formatString = formatStringOverride;
		validPatternChars = validPatternCharsOverride;
	}

	/**
	 *  Formats the String as a phone number.
	 *  If the value cannot be formatted, return an empty String 
	 *  and write a description of the error to the <code>error</code> property.
	 *
	 *  @param value Value to format.
	 *
	 *  @return Formatted String. Empty if an error occurs. A description 
	 *  of the error condition is written to the <code>error</code> property.
	 */
	override public function format(value:Dynamic):String {
		// Reset any previous errors.
		if (error != null) {
			error = null;
		}

		// --value--

		if (value == null || Std.string(value).length == 0 || Math.isNaN(Std.parseFloat(Std.string(value)))) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// --length--

		var fStrLen:Int = 0;
		var letter:String;
		var n:Int;

		n = formatString.length;
		for (i in 0...n) {
			letter = formatString.charAt(i);
			if (letter == "#") {
				fStrLen++;
			} else if (validPatternChars.indexOf(letter) == -1) {
				error = Formatter.defaultInvalidFormatError;
				return "";
			}
		}

		if (Std.string(value).length != fStrLen) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// --format--

		var fStr:String = formatString;

		if (fStrLen == 7 && areaCode != -1) {
			var aCodeLen:Int = 0;
			n = areaCodeFormat.length;
			for (i in 0...n) {
				if (areaCodeFormat.charAt(i) == "#") {
					aCodeLen++;
				}
			}
			if (aCodeLen == 3 && Std.string(areaCode).length == 3) {
				fStr = Std.string(areaCodeFormat) + fStr;
				value = Std.string(areaCode) + Std.string(value);
			}
		}

		var dataFormatter:SwitchSymbolFormatter = new SwitchSymbolFormatter();

		return dataFormatter.formatValue(fStr, value);
	}
}
