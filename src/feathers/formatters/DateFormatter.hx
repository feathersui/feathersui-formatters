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
	The DateFormatter class uses a format String to return a formatted date and time String
	from an input String or a Date object.
	You can create many variations easily, including international formats.

	If an error occurs, an empty String is returned and a String describing 
	the error is saved to the `error` property. The `error` 
	property can have one of the following values:

	- `"Invalid value"` means a value that is not a Date object or a 
	is not a recognized String representation of a date is
	passed to the `format()` method. (An empty argument is allowed.)
	- `"Invalid format"` means either the `formatString` 
	property is set to empty (""), or there is less than one pattern letter 
	in the `formatString` property.

	The `parseDateString()` method uses the feathers.formatters.DateBase class
	to define the localized string information required to convert 
	a date that is formatted as a String into a Date object.

	@see `feathers.formatters.DateBase`
**/
class DateFormatter extends Formatter {
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	private static final VALID_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S,Q,O,Z";

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
		Converts a date that is formatted as a String into a Date object.
		Month and day names must match the names in feathers.formatters.DateBase.

		The hour value in the String must be between 0 and 23, inclusive. 
		The minutes and seconds value must be between 0 and 59, inclusive.
		The following example uses this method to create a Date object:

		```haxe
		var myDate:Date = DateFormatter.parseDateString("2009-12-02 23:45:30");
		```

		The optional format property is use to work out which is likly to be encountered
		first a month or a date of the month for date where it may not be obvious which
		comes first.

		@see `feathers.formatters.DateBase`

		@param str Date that is formatted as a String. 

		@return Date object.
	**/
	public static function parseDateString(str:String, format:String = null):Date {
		if (str == null || str == "") {
			return null;
		}

		var year:Int = -1;
		var mon:Int = -1;
		var day:Int = -1;
		var hour:Int = -1;
		var min:Int = -1;
		var sec:Int = -1;
		var milli:Int = -1;

		var letter:String = "";
		var marker:Dynamic = 0;

		var count:Int = 0;
		var len:Int = 0;
		var isPM:Bool = false;

		var punctuation:Dynamic = {};
		var ampm:Dynamic = {};

		Reflect.setField(punctuation, "/", {general: true, date: true, time: false});
		Reflect.setField(punctuation, ":", {general: true, date: false, time: true});
		Reflect.setField(punctuation, " ", {general: true, date: true, time: false});
		Reflect.setField(punctuation, ".", {general: true, date: true, time: true});
		Reflect.setField(punctuation, ",", {general: true, date: true, time: false});
		Reflect.setField(punctuation, "+", {general: true, date: false, time: false});
		Reflect.setField(punctuation, "-", {general: true, date: true, time: false});
		// Chinese and Japanese
		Reflect.setField(punctuation, "年", {general: true, date: true, time: false});
		Reflect.setField(punctuation, "月", {general: true, date: true, time: false});
		Reflect.setField(punctuation, "日", {general: true, date: true, time: false});
		Reflect.setField(punctuation, "午", {general: false, date: false, time: true});
		// Korean
		Reflect.setField(punctuation, "년", {general: true, date: true, time: false});
		Reflect.setField(punctuation, "월", {general: true, date: true, time: false});
		Reflect.setField(punctuation, "일", {general: true, date: true, time: false});

		Reflect.setField(ampm, "PM", true);
		Reflect.setField(ampm, "pm", true);
		Reflect.setField(ampm, "\u33D8", true); // unicode pm
		Reflect.setField(ampm, "μμ", true); // Greek
		Reflect.setField(ampm, "午後", true); // Japanese
		Reflect.setField(ampm, "上午", true); // Chinese
		Reflect.setField(ampm, "오후", true); // Korean

		// Strip out the Timezone. It is not used by the DateFormatter
		var timezoneRegEx = ~/(GMT|UTC)((\+|-)\d\d\d\d )?/ig;

		str = timezoneRegEx.replace(str, "");
		len = str.length;

		while (count < len) {
			letter = str.charAt(count);
			count++;

			// If the letter is a blank space or a comma,
			// continue to the next character
			if (letter <= " " || letter == ",") {
				continue;
			}

			// If the letter is a key punctuation character,
			// cache it for the next time around.
			if (Reflect.hasField(punctuation, letter) && Reflect.field(punctuation, letter).general) {
				marker = letter;
				continue;
			}

			// Scan for groups of numbers and letters
			// and match them to Date parameters
			if (!("0" <= letter && letter <= "9" || Reflect.hasField(punctuation, letter) && Reflect.field(punctuation, letter).general)) {
				// Scan for groups of letters
				var word:String = letter;
				while (count < len) {
					letter = str.charAt(count);
					if ("0" <= letter
						&& letter <= "9"
						|| Reflect.hasField(punctuation, letter)
						&& Reflect.field(punctuation, letter).general) {
						break;
					}
					word += letter;
					count++;
				}

				// Allow for an exact match
				// or a match to the first 3 letters as a prefix.
				var n:Int = @:privateAccess DateBase.defaultStringKey.length;
				for (i in 0...n) {
					var s:String = Std.string(@:privateAccess DateBase.defaultStringKey[i]);
					if (s.toLowerCase() == word.toLowerCase() || s.toLowerCase().substr(0, 3) == word.toLowerCase()) {
						if (i == 13) {
							// pm
							if (hour > 12 || hour < 1)
								break; // error
							else if (hour < 12)
								hour += 12;
						} else if (i == 12) {
							// am
							if (hour > 12 || hour < 1)
								break; // error
							else if (hour == 12)
								hour = 0;
						} else if (i < 12) {
							// month
							if (mon < 0)
								mon = i;
							else
								break; // error
						}
						break;
					}
				}
				marker = 0;

				// All known locales AM/PM
				if (ampm.hasOwnProperty(word)) {
					isPM = true;

					if (hour > 12)
						break; // error
					else if (hour >= 0 && hour < 12)
						hour += 12;
				}
			} else if ("0" <= letter && letter <= "9") {
				// Scan for groups of numbers
				var numbers:String = letter;
				while ("0" <= (letter = str.charAt(count)) && letter <= "9" && count < len) {
					numbers += letter;
					count++;
				}
				var num:Int = Std.parseInt(numbers);

				// If num is a number greater than 70, assign num to year.
				// if after seconds and a dot or colon more likly milliseconds
				if (num >= 70 && !(Reflect.hasField(punctuation, letter) && Reflect.field(punctuation, letter).time == true && sec >= 0)) {
					if (year != -1) {
						break; // error
					} else if (Reflect.hasField(punctuation, letter) && Reflect.field(punctuation, letter).date == true || count >= len) {
						year = num;
					} else {
						break; // error
					}
				}

					// If the current letter is a slash or a dash,
				// assign num to year or month or day or min or sec.
				else if (Reflect.hasField(punctuation, letter) && Reflect.field(punctuation, letter).date == true) {
					var monthFirst:Bool = year != -1;

					if (format != null && format.length > 0) {
						monthFirst = monthFirst || format.indexOf("M") < format.indexOf("D");
					}

					if (monthFirst && mon < 0) {
						mon = (num - 1);
					} else if (day < 0) {
						day = num;
					} else if (!monthFirst && mon < 0) {
						mon = (num - 1);
					} else if (min < 0) {
						min = num;
					} else if (sec < 0) {
						sec = num;
					} else if (milli < 0) {
						milli = num;
					} else {
						break; // error
					}
				}

					// If the current letter is a colon or a dot,
				// assign num to hour or minute or sec.
				else if (Reflect.hasField(punctuation, letter) && Reflect.field(punctuation, letter).time == true) {
					if (hour < 0) {
						hour = num;

						if (isPM) {
							if (hour > 12)
								break; // error
							else if (hour >= 0 && hour < 12)
								hour += 12;
						}
					} else if (min < 0)
						min = num;
					else if (sec < 0)
						sec = num;
					else if (milli < 0)
						milli = num;
					else
						break; // error
				}

					// If hours are defined and minutes are not,
				// assign num to minutes.
				else if (hour >= 0 && min < 0) {
					min = num;
				}

					// If minutes are defined and seconds are not,
				// assign num to seconds.
				else if (min >= 0 && sec < 0) {
					sec = num;
				}

					// If seconds are defined and millis are not,
				// assign num to mills.
				else if (sec >= 0 && milli < 0) {
					milli = num;
				}

				// If day is not defined, assign num to day.
				else if (day < 0) {
					day = num;
				}

					// If month and day are defined and year is not,
				// assign num to year.
				else if (year < 0 && mon >= 0 && day >= 0) {
					year = 2000 + num;
				}

				// Otherwise, break the loop
				else {
					break; // error
				}

				marker = 0;
			}
		}

		if (year < 0 || mon < 0 || mon > 11 || day < 1 || day > 31) {
			return null; // error - needs to be a date
		}

		// Time is set to 0 if null.
		if (milli < 0) {
			milli = 0;
		}
		if (sec < 0) {
			sec = 0;
		}
		if (min < 0) {
			min = 0;
		}
		if (hour < 0) {
			hour = 0;
		}

		// create a date object and check the validity of the input date
		// by comparing the result with input values.
		var newDate:Date = new Date(year, mon, day, hour, min, sec /*, milli*/);
		if (day != newDate.getDate() || mon != newDate.getMonth()) {
			return null;
		}

		return newDate;
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.

		@param formatString Date format pattern is set to this DateFormatter.
	**/
	public function new(formatString:String = null) {
		super();

		this.formatString = formatString;
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

		You compose a pattern String using specific uppercase letters,
		for example: YYYY/MM.

		The DateFormatter pattern String can contain other text
		in addition to pattern letters.
		To form a valid pattern String, you only need one pattern letter.
			
		The following table describes the valid pattern letters:

		**Y**

		Year. If the number of pattern letters is two, the year is 
		truncated to two digits; otherwise, it appears as four digits. 
		The year can be zero-padded, as the third example shows in the 
		following set of examples: 
			
		- YY = 05
		- YYYY = 2005
		- YYYYY = 02005

		**M**

		Month in year. The format depends on the following criteria:
			
		- If the number of pattern letters is one, the format is 
			interpreted as numeric in one or two digits.
		- If the number of pattern letters is two, the format 
			is interpreted as numeric in two digits.
		- If the number of pattern letters is three, 
			the format is interpreted as short text.
		- If the number of pattern letters is four, the format 
			is interpreted as full text.

		Examples:

		- M=  7
		- MM = 07
		- MMM = Jul
		- MMMM = July

		**D**

		Day in month. While a single-letter pattern string for day is valid, 
		you typically use a two-letter pattern string.

		Examples:

		- D = 4
		- DD = 04
		- DD = 10

		**E**

		Day in week. The format depends on the following criteria:

		- If the number of pattern letters is one, the format is 
			interpreted as numeric in one or two digits.
		- If the number of pattern letters is two, the format is interpreted 
			as numeric in two digits.
		- If the number of pattern letters is three, the format is interpreted 
			as short text. 
		- If the number of pattern letters is four, the format is interpreted 
			as full text. 

		Examples:

		- E = 1
		- EE = 01
		- EEE = Mon
		- EEEE = Monday

		**A**

		am/pm indicator.

		**J**

		Hour in day (0-23).

		**H**

		Hour in day (1-24).

		**K**

		Hour in am/pm (0-11).

		**L**

		Hour in am/pm (1-12).

		**N**

		Minute in hour.

		Examples:

		- N = 3
		- NN = 03

		**S**

		Second in minute. 

		Example:

		- SS = 30

		**Q**

		Millisecond in second

		Example:

		- QQ = 78
		- QQQ = 078

		**O**

		Timezone offset

		Example:

		- O = +7
		- OO = -08
		- OOO = +4:30
		- OOOO = -08:30

		**Z**

		Timezone name

		Example:

		- Z = GMT

		**Other text**

		You can add other text into the pattern string to further 
		format the string. You can use punctuation, numbers, 
		and all lowercase letters. You should avoid uppercase letters 
		because they may be interpreted as pattern letters.

		Example:

		- EEEE, MMM. D, YYYY at L:NN:QQQ A = Tuesday, Sept. 8, 2005 at 1:26:012 PM

		@default "MM/DD/YYYY"
	**/
	public var formatString(get, set):String;

	private function get_formatString():String {
		return _formatString;
	}

	private function set_formatString(value:String):String {
		formatStringOverride = value;

		_formatString = value != null ? value : "MM/DD/YYYY";
		return _formatString;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override private function resourcesChanged():Void {
		super.resourcesChanged();

		formatString = formatStringOverride;
	}

	/**
		Generates a date-formatted String from either a date-formatted String or a Date object. 
		The `formatString` property
		determines the format of the output String.
		If `value` cannot be formatted, return an empty String 
		and write a description of the error to the `error` property.

		@param value Date to format. This can be a Date object,
		or a date-formatted String such as "Thursday, April 22, 2004".

		@return Formatted String. Empty if an error occurs. A description 
		of the error condition is written to the `error` property.
	**/
	override public function format(value:Dynamic):String {
		// Reset any previous errors.
		if (error != null) {
			error = null;
		}

		// If value is null, or empty String just return ""
		// but treat it as an error for consistency.
		// Users will ignore it anyway.
		if (value == null || ((value is String) && value == "")) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// -- value --

		if ((value is String)) {
			value = DateFormatter.parseDateString((value : String), formatString);
			if (value == null) {
				error = Formatter.defaultInvalidValueError;
				return "";
			}
		} else if (!(value is Date)) {
			error = Formatter.defaultInvalidValueError;
			return "";
		}

		// -- format --

		var letter:String;
		var nTokens:Int = 0;
		var tokens:String = "";

		var n:Int = formatString.length;
		for (i in 0...n) {
			letter = formatString.charAt(i);
			if (VALID_PATTERN_CHARS.indexOf(letter) != -1 && letter != ",") {
				nTokens++;
				if (tokens.indexOf(letter) == -1) {
					tokens += letter;
				} else {
					if (letter != formatString.charAt(Std.int(Math.max(i - 1, 0)))) {
						error = Formatter.defaultInvalidFormatError;
						return "";
					}
				}
			}
		}

		if (nTokens < 1) {
			error = Formatter.defaultInvalidFormatError;
			return "";
		}

		var dataFormatter:StringFormatter = new StringFormatter(formatString, VALID_PATTERN_CHARS, @:privateAccess DateBase.extractTokenDate);

		return dataFormatter.formatValue(value);
	}
}
