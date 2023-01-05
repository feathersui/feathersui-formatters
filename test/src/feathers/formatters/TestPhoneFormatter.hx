package feathers.formatters;

import utest.Assert;
import utest.Test;

class TestPhoneFormatter extends Test {
	private var _formatter:PhoneFormatter;

	public function setup():Void {
		_formatter = new PhoneFormatter();
	}

	public function teardown():Void {
		_formatter = null;
	}

	public function testDefaultsString():Void {
		var result = _formatter.format("1234567890");
		Assert.equals("(123) 456-7890", result);
	}

	public function testDefaultsInteger():Void {
		var result = _formatter.format(1234567890);
		Assert.equals("(123) 456-7890", result);
	}
}
