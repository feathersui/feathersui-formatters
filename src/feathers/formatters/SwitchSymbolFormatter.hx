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
	The SwitchSymbolFormatter class is a utility class that you can use 
	when creating custom formatters.
	This class performs a substitution by replacing placeholder characters
	in one String with numbers from a second String.

	For example, you specify the following information
	to the SwitchSymbolFormatter class:<

	Format String: "The SocialSecurity number is: ###-##-####"

	Input String: "123456789"

	The SwitchSymbolFormatter class parses the format String and replaces
	each placeholder character, by default the number character (#), 
	with a number from the input String in the order in which
	the numbers are specified in the input String.
	You can define a different placeholder symbol by passing it
	to the constructor when you instantiate a SwitchSymbolFormatter object.

	The output String created by the SwitchSymbolFormatter class
	from these two Strings is the following:

	"The SocialSecurity number is: 123-45-6789"

	The pattern can contain any characters as long as they are constant
	for all values of the numeric portion of the String.
	However, the value for formatting must be numeric.

	The number of digits supplied in the source value must match
	the number of digits defined in the pattern String.
	This is the responsibility of the script calling the
	SwitchSymbolFormatter object.

	@see `feathers.formatters.PhoneFormatter`
	@see `feathers.formatters.ZipCodeFormatter`
**/
class SwitchSymbolFormatter {
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.

		@param numberSymbol Character to use as the pattern character.
	**/
	public function new(numberSymbol:String = "#") {
		this.numberSymbol = numberSymbol;
		isValid = true;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	private var numberSymbol:String;

	private var isValid:Bool;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
		Creates a new String by formatting the source String
		using the format pattern.

		@param format String that defines the user-requested pattern including.

		@param source Valid number sequence
		(alpha characters are allowed if needed).

		@return Formatted String.
	**/
	public function formatValue(format:String, source:Dynamic):String {
		var numStr:String = "";

		var uStrIndx:Int = 0;

		var n:Int = format.length;
		for (i in 0...n) {
			var letter:String = format.charAt(i);
			if (letter == numberSymbol) {
				numStr += Std.string(source).charAt(uStrIndx++);
			} else {
				numStr += format.charAt(i);
			}
		}

		return numStr;
	}
}
