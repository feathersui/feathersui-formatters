package feathers.formatters;

import utest.Assert;
import utest.Test;

class TestDateFormatter extends Test {
	private var _formatter:DateFormatter;

	public function setup():Void {
		_formatter = new DateFormatter();
	}

	public function teardown():Void {
		_formatter = null;
	}

	public function testDefaultsWithDate():Void {
		var result = _formatter.format(new Date(1981, 8, 3, 0, 0, 0));
		Assert.equals("09/03/1981", result);
	}

	public function testDefaultsWithString():Void {
		var result = _formatter.format("1981-09-03");
		Assert.equals("09/03/1981", result);
	}

	public function testDefaultsWithInvalidType():Void {
		var result = _formatter.format(12345);
		Assert.equals("", result);
		Assert.equals(Formatter.defaultInvalidValueError, _formatter.error);
	}

	public function testFormatString():Void {
		_formatter.formatString = "DD/MM/YYYY";
		var result = _formatter.format(new Date(1981, 8, 3, 0, 0, 0));
		Assert.equals("03/09/1981", result);
	}

	public function testFormatStringShortValues():Void {
		_formatter.formatString = "M/D/YY";
		var result = _formatter.format(new Date(1981, 8, 3, 0, 0, 0));
		Assert.equals("9/3/81", result);
	}
}
