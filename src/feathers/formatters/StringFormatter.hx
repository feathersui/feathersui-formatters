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
	The StringFormatter class provides a mechanism for displaying
	and saving data in the specified format.
	The constructor accepts the format and an Array of tokens,
	and uses these values to create the data structures to support
	the formatting during data retrieval and saving. 

	This class is used internally by other formatters,
	and is typically not used directly.

	@see `feathers.formatters.DateFormatter`
**/
@:dox(hide)
@:noCompletion
class StringFormatter {
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
		Constructor.

		@param format String that contains the desired format.

		@param tokens String that contains the character tokens
		within the specified format String that is replaced
		during data formatting operations.

		@param extractTokenFunc The token 
		accessor method to call when formatting for display.
		The method signature is
		value: anything, tokenInfo: {token: id, begin: start, end: finish}.
		This method must return a String representation of value
		for the specified `tokenInfo`.
	**/
	public function new(format:String, tokens:String, extractTokenFunc:(Dynamic, PatternInfo) -> String) {
		formatPattern(format, tokens);
		extractToken = extractTokenFunc;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	private var extractToken:(Dynamic, PatternInfo) -> String;

	private var reqFormat:String;

	private var patternInfo:Array<PatternInfo>;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
		Returns the formatted String using the format, tokens,
		and extraction function passed to the constructor.

		@param value String to be formatted.

		@return Formatted String.
	**/
	public function formatValue(value:Dynamic):String {
		var curTokenInfo:Dynamic = patternInfo[0];

		var result:String = reqFormat.substring(0, curTokenInfo.begin) + extractToken(value, curTokenInfo);

		var lastTokenInfo:Dynamic = curTokenInfo;

		var n:Int = patternInfo.length;
		for (i in 1...n) {
			curTokenInfo = patternInfo[i];

			result += reqFormat.substring(lastTokenInfo.end, curTokenInfo.begin) + extractToken(value, curTokenInfo);

			lastTokenInfo = curTokenInfo;
		}
		if (lastTokenInfo.end > 0 && lastTokenInfo.end != reqFormat.length) {
			result += reqFormat.substring(lastTokenInfo.end);
		}

		return result;
	}

	/**
		Formats a user-defined pattern String into a more usable object.

		@param format String that defines the user-requested pattern.

		@param tokens List of valid patttern characters.
	**/
	private function formatPattern(format:String, tokens:String):Void {
		var start:Int = 0;
		var finish:Int = 0;
		var index:Int = 0;

		var tokenArray:Array<String> = tokens.split(",");

		reqFormat = format;

		patternInfo = [];

		var n:Int = tokenArray.length;
		for (i in 0...n) {
			start = reqFormat.indexOf(tokenArray[i]);
			if (start >= 0 && start < reqFormat.length) {
				finish = reqFormat.lastIndexOf(tokenArray[i]);
				finish = finish >= 0 ? finish + 1 : start + 1;
				patternInfo.insert(index, {token: tokenArray[i], begin: start, end: finish});
				index++;
			}
		}

		patternInfo.sort(compareValues);
	}

	private function compareValues(a:PatternInfo, b:PatternInfo):Int {
		if (a.begin > b.begin) {
			return 1;
		} else if (a.begin < b.begin) {
			return -1;
		} else {
			return 0;
		}
	}
}

typedef PatternInfo = {
	token:String,
	begin:Int,
	end:Int
}
