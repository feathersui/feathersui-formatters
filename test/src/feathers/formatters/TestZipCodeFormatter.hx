package feathers.formatters;

import utest.Assert;
import utest.Test;

class TestZipCodeFormatter extends Test {
	private var _formatter:ZipCodeFormatter;

	public function setup():Void {
		_formatter = new ZipCodeFormatter();
	}

	public function teardown():Void {
		_formatter = null;
	}

	public function testDefaults():Void {
		var result = _formatter.format("12345");
		Assert.equals("12345", result);
	}
}
