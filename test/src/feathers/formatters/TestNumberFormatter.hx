package feathers.formatters;

import utest.Assert;
import utest.Test;

class TestNumberFormatter extends Test {
	private var _formatter:NumberFormatter;

	public function setup():Void {
		_formatter = new NumberFormatter();
	}

	public function teardown():Void {
		_formatter = null;
	}

	public function testDefaultsString():Void {
		var result = _formatter.format("1234567890");
		Assert.equals("1,234,567,890", result);
	}

	public function testDefaultsInteger():Void {
		var result = _formatter.format(1234567890);
		Assert.equals("1,234,567,890", result);
	}

	public function testDefaultsFloat():Void {
		var result = _formatter.format(1234567.89);
		Assert.equals("1,234,567.89", result);
	}
}
