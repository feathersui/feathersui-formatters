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

import feathers.formatters.StringFormatter.PatternInfo;

/**
 *  The DateBase class contains the localized string information
 *  used by the feathers.formatters.DateFormatter class and the parsing function
 *  that renders the pattern.
 *  This is a helper class for the DateFormatter class that is not usually
 *  used independently.
 *
 *  @see `feathers.formatters.DateFormatter`
 */
class DateBase {
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
	//  dayNamesLong
	//----------------------------------
	private static var _dayNamesLong:Array<String>;

	private static var dayNamesLongOverride:Array<String>;

	/**
	 *  Long format of day names.
	 * 
	 *  @default ["Sunday", "Monday", "Tuesday", "Wednesday",
	 *  "Thursday", "Friday", "Saturday"]
	 */
	public static var dayNamesLong(get, set):Array<String>;

	private static function get_dayNamesLong():Array<String> {
		initialize();

		return _dayNamesLong;
	}

	private static function set_dayNamesLong(value:Array<String>):Array<String> {
		dayNamesLongOverride = value;

		_dayNamesLong = value != null ? value : ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		return _dayNamesLong;
	}

	//----------------------------------
	//  dayNamesShort
	//----------------------------------
	private static var _dayNamesShort:Array<String>;

	private static var dayNamesShortOverride:Array<String>;

	/**
	 *  Short format of day names.
	 * 
	 *  @default ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	 */
	public static var dayNamesShort(get, set):Array<String>;

	private static function get_dayNamesShort():Array<String> {
		initialize();

		return _dayNamesShort;
	}

	private static function set_dayNamesShort(value:Array<String>):Array<String> {
		dayNamesShortOverride = value;

		_dayNamesShort = value != null ? value : ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		return _dayNamesShort;
	}

	//----------------------------------
	//  defaultStringKey
	//----------------------------------
	private static var defaultStringKey(get, never):Array<String>;

	private static function get_defaultStringKey():Array<String> {
		initialize();

		return monthNamesLong.concat(timeOfDay);
	}

	//----------------------------------
	//  monthNamesLong
	//----------------------------------
	private static var _monthNamesLong:Array<String>;

	private static var monthNamesLongOverride:Array<String>;

	/**
	 *  Long format of month names.
	 *
	 *  @default ["January", "February", "March", "April", "May", "June", 
	 *  "July", "August", "September", "October", "November", "December"]
	 */
	public static var monthNamesLong(get, set):Array<String>;

	private static function get_monthNamesLong():Array<String> {
		initialize();

		return _monthNamesLong;
	}

	private static function set_monthNamesLong(value:Array<String>):Array<String> {
		monthNamesLongOverride = value;

		_monthNamesLong = value != null ? value : [
			"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
		];
		return _monthNamesLong;
	}

	//----------------------------------
	//  monthNamesShort
	//----------------------------------
	private static var _monthNamesShort:Array<String>;

	private static var monthNamesShortOverride:Array<String>;

	/**
	 *  Short format of month names.
	 *
	 *  @default ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
	 *  "Jul", "Aug", "Sep", "Oct","Nov", "Dec"]
	 */
	public static var monthNamesShort(get, set):Array<String>;

	private static function get_monthNamesShort():Array<String> {
		initialize();

		return _monthNamesShort;
	}

	private static function set_monthNamesShort(value:Array<String>):Array<String> {
		monthNamesShortOverride = value;

		_monthNamesShort = value != null ? value : [
			"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
		];
		return _monthNamesShort;
	}

	//----------------------------------
	//  timeOfDay
	//----------------------------------
	private static var _timeOfDay:Array<String>;

	private static var timeOfDayOverride:Array<String>;

	/**
	 *  Time of day names.
	 * 
	 *  @default ["AM", "PM"]
	 */
	public static var timeOfDay(get, set):Array<String>;

	private static function get_timeOfDay():Array<String> {
		initialize();

		return _timeOfDay;
	}

	private static function set_timeOfDay(value:Array<String>):Array<String> {
		timeOfDayOverride = value;

		_timeOfDay = value != null ? value : ["AM", "PM"];
		return _timeOfDay;
	}

	private static var _timezoneName:String = "GMT";

	/**
	 *  Timezone name.
	 * 
	 *  @default "GMT"
	 */
	public static var timezoneName(get, set):String;

	private static function get_timezoneName():String {
		return _timezoneName;
	}

	private static function set_timezoneName(value:String):String {
		_timezoneName = value;
		return _timezoneName;
	}

	private static var _timezoneHourMinuteSeperator:String = ":";

	/**
	 *  Timezone hour/minute seperator.
	 * 
	 *  @default ":"
	 */
	public static var timezoneHourMinuteSeperator(get, set):String;

	private static function get_timezoneHourMinuteSeperator():String {
		return _timezoneHourMinuteSeperator;
	}

	private static function set_timezoneHourMinuteSeperator(value:String):String {
		_timezoneHourMinuteSeperator = value;
		return _timezoneHourMinuteSeperator;
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
		dayNamesLong = dayNamesLongOverride;
		dayNamesShort = dayNamesShortOverride;
		monthNamesLong = monthNamesLongOverride;
		monthNamesShort = monthNamesShortOverride;
		timeOfDay = timeOfDayOverride;
	}

	/**
	 *  Parses token objects and renders the elements of the formatted String.
	 *  For details about token objects, see StringFormatter.
	 *
	 *  @param date Date object.
	 *
	 *  @param tokenInfo Array object that contains token object descriptions.
	 *
	 *  @return Formatted string.
	 */
	private static function extractTokenDate(date:Date, tokenInfo:PatternInfo):String {
		initialize();

		var result:String = "";

		var key:Int = tokenInfo.end - tokenInfo.begin;

		switch (tokenInfo.token) {
			case "Y":
				{
					// year
					var year:String = Std.string(date.getFullYear());
					if (key < 3) {
						return year.substr(2);
					} else if (key > 4) {
						return setValue(Std.parseFloat(year), key);
					} else {
						return year;
					}
				}

			case "M":
				{
					// month in year
					var month:Int = date.getMonth();
					if (key < 3) {
						month++; // zero based
						result += setValue(month, key);
						return result;
					} else if (key == 3) {
						return monthNamesShort[month];
					} else {
						return monthNamesLong[month];
					}
				}

			case "D":
				{
					// day in month
					var day:Int = date.getDate();
					result += setValue(day, key);
					return result;
				}

			case "E":
				{
					// day in the week
					var day:Int = date.getDay();
					if (key < 3) {
						result += setValue(day, key);
						return result;
					} else if (key == 3) {
						return dayNamesShort[day];
					} else {
						return dayNamesLong[day];
					}
				}

			case "A":
				{
					// am/pm marker
					var hours:Int = date.getHours();
					if (hours < 12) {
						return timeOfDay[0];
					} else {
						return timeOfDay[1];
					}
				}

			case "H":
				{
					// hour in day (1-24)
					var hours:Int = date.getHours();
					if (hours == 0) {
						hours = 24;
					}
					result += setValue(hours, key);
					return result;
				}

			case "J":
				{
					// hour in day (0-23)
					var hours:Int = date.getHours();
					result += setValue(hours, key);
					return result;
				}

			case "K":
				{
					// hour in am/pm (0-11)
					var hours:Int = date.getHours();
					if (hours >= 12) {
						hours = hours - 12;
					}
					result += setValue(hours, key);
					return result;
				}

			case "L":
				{
					// hour in am/pm (1-12)
					var hours:Int = date.getHours();
					if (hours == 0) {
						hours = 12;
					} else if (hours > 12) {
						hours = hours - 12;
					}
					result += setValue(hours, key);
					return result;
				}

			case "N":
				{
					// minutes in hour
					var mins:Int = date.getMinutes();
					result += setValue(mins, key);
					return result;
				}

			case "S":
				{
					// seconds in minute
					var sec:Int = date.getSeconds();
					result += setValue(sec, key);
					return result;
				}

			case "Q":
				{
					// milliseconds in second
					var ms:Int = 0; // date.getMilliseconds();
					result += setValue(ms, key);
					return result;
				}

			case "Z":
				{
					// timezone offset
					result += timezoneName;
					return result;
				}

			case "O":
				{
					// timezone offset
					var offset:Int = -1 * date.getTimezoneOffset();
					var hours:Int = Std.int(offset / 60);
					var mins:Int = offset - hours * 60;
					var tzStr:String = "";

					if (key <= 2 && mins == 0) {
						tzStr += setValue(hours, key);
					} else {
						tzStr += setValue(hours, key - 2) + timezoneHourMinuteSeperator + setValue(mins, 2);
					}

					if (offset >= 0) {
						tzStr = "+" + tzStr;
					}

					result += tzStr;

					return result;
				}
		}

		return result;
	}

	/**
	 *  Makes a given length of digits longer by padding with zeroes.
	 *
	 *  @param value Value to pad.
	 *
	 *  @param key Length of the string to pad.
	 *
	 *  @return Formatted string.
	 */
	private static function setValue(value:Dynamic, key:Int):String {
		var result:String = "";

		var vLen:Int = Std.string(value).length;
		if (vLen < key) {
			var n:Int = key - vLen;
			for (i in 0...n) {
				result += "0";
			}
		}

		result += Std.string(value);

		return result;
	}
}
