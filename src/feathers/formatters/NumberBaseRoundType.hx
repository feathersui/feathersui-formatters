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
	The NumberBaseRoundType class defines the constant values for formatter properties
	that specify a type of rounding. For example, you can set the 
	`NumberFormatter.rounding` property using these constants.

	@see `feathers.formatters.NumberFormatter`
	@see `feathers.formatters.NumberBase`
**/
final class NumberBaseRoundType {
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
		Rounds a number down to an integer that is both closest to, 
		and less than or equal to, the input number.
	**/
	public static final DOWN:String = "down";

	/**
		Rounds a number up or down to the nearest integer.
	**/
	public static final NEAREST:String = "nearest";

	/**
		Perform no rounding.
	**/
	public static final NONE:String = "none";

	/**
		Rounds a number up to an integer value that is both closest to, 
		and greater than or equal to, the input number.
	**/
	public static final UP:String = "up";
}
