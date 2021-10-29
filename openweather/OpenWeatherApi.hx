package openweather;

import openweather.Types.WeatherResponse;
import js.lib.Promise;
import tink.http.Client.fetch;

class OpenWeatherApi {
	static var API_BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
	static var ICON_BASE_URL = 'https://openweathermap.org/img/wn/';
	public static var apiKey:String;
	public static var lang:String;
	public static var units:String;

	static public function getWeatherById(id:UInt):Promise<WeatherResponse> {
		return getWeather('id=$id');
	}

	static public function getWeatherByLocation(loc:{lat:Float, lon:Float}):Promise<WeatherResponse> {
		return getWeather('lat=${loc.lat}&lon=${loc.lon}');
	}

	static public function getWeatherByName(name:String):Promise<WeatherResponse> {
		return getWeather('q=$name');
	}

	static function getWeather(query:String):Promise<WeatherResponse> {
		return new Promise((resolve, reject) -> {
			fetch('$API_BASE_URL?lang=$lang&units=$units&appid=$apiKey&$query').all().handle(o -> switch o {
				case Success(res):
					resolve((tink.Json.parse(res.body.toString()) : WeatherResponse));
				case Failure(e):
					reject(e);
			});
		});
	}

	public static function getIcon(id:String):Promise<haxe.io.Bytes> {
		return new Promise((resolve, reject) -> {
			fetch('$ICON_BASE_URL$id.png').all().handle(o -> switch o {
				case Success(res):
					resolve(res.body.toBytes());
				case Failure(e):
					reject(e);
			});
		});
	}
}
