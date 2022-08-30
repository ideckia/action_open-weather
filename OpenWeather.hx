package;

import haxe.crypto.Base64;
import openweather.OpenWeatherApi;
import openweather.Types.WeatherResponse;

using api.IdeckiaApi;

typedef Props = {
	@:editable("OpenWeather API key (get it here: https://openweathermap.org/appid)", null)
	var open_weather_key:String;
	@:editable("Update interval in minutes", 15)
	var update_interval:UInt;
	@:editable("Which language do you want the description", 'en', [
		'af (Afrikaans)',
		'al (Albanian)',
		'ar (Arabic)',
		'az (Azerbaijani)',
		'bg (Bulgarian)',
		'ca (Catalan)',
		'cz (Czech)',
		'da (Danish)',
		'de (German)',
		'el (Greek)',
		'en (English)',
		'eu (Basque)',
		'fa (Persian (Farsi))',
		'fi (Finnish)',
		'fr (French)',
		'gl (Galician)',
		'he (Hebrew)',
		'hi (Hindi)',
		'hr (Croatian)',
		'hu (Hungarian)',
		'id (Indonesian)',
		'it (Italian)',
		'ja (Japanese)',
		'kr (Korean)',
		'la (Latvian)',
		'lt (Lithuanian)',
		'mk (Macedonian)',
		'no (Norwegian)',
		'nl (Dutch)',
		'pl (Polish)',
		'pt (Portuguese)',
		'pt_br (Português Brasil)',
		'ro (Romanian)',
		'ru (Russian)',
		'sv (Swedish)',
		'sk (Slovak)',
		'sl (Slovenian)',
		'es (Spanish)',
		'sr (Serbian)',
		'th (Thai)',
		'tr (Turkish)',
		'uk (Ukrainian)',
		'vi (Vietnamese)',
		'zh_cn (Chinese Simplified)',
		'zh_tw (Chinese Traditional)',
		'zu (Zulu)'
	])
	var language:String;
	@:editable('Units of measurement', 'metric', ['metric', 'standard', 'imperial'])
	var units:String;
	@:editable("OpenWeather town id array (get the IDs from https://openweathermap.org/current#cityid)", [])
	var town_ids:Array<UInt>;
	@:editable("Towns Locations array (latitude and longitude values).", [])
	var town_locations:Array<{lat:Float, lon:Float}>;
	@:editable("Towns names array. City name, state code and country code divided by comma. Please, refer to ISO 3166 for the state codes or country codes.",
		[])
	var town_names:Array<String>;
}

enum TypeOfSearch {
	id;
	location;
	name;
}

@:name("open-weather")
@:description("Get weather information from openweathermap.org")
class OpenWeather extends IdeckiaAction {
	var state:ItemState;
	var currentTownIndex:UInt;
	var typeOfSearch:TypeOfSearch;
	var tempUnit:String;

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		var townIdsLength = props.town_ids.length;
		var townLocationsLength = props.town_locations.length;
		var townNamesLength = props.town_names.length;
		currentTownIndex = 0;

		switch [townIdsLength, townLocationsLength, townNamesLength] {
			case [x, 0, 0] if (x > 0):
				typeOfSearch = id;
			case [0, x, 0] if (x > 0):
				typeOfSearch = location;
			case [0, 0, x] if (x > 0):
				typeOfSearch = name;
			case [0, 0, 0]:
				currentTownIndex = -1;
				server.dialog.error('OpenWeather error', 'Please provide the towns (id, location or name) to search the weater for.');
			case [x, y, z]:
				server.log.info('Only one type of search will be accepted.');
				if (x > 0)
					typeOfSearch = id;
				else if (y > 0)
					typeOfSearch = location;
				else if (z > 0)
					typeOfSearch = name;
		}

		state = initialState;

		if (props.open_weather_key == null) {
			currentTownIndex = -1;
			server.dialog.error('OpenWeather error', 'Please provide the OpenWeather APP key (get it here: https://openweathermap.org/appid)');
		}

		tempUnit = switch props.units {
			case 'standard': 'K';
			case 'imperial': 'ºF';
			default: 'ºC';
		};

		OpenWeatherApi.apiKey = props.open_weather_key;

		OpenWeatherApi.lang = StringTools.trim(props.language.split('(')[0]);
		OpenWeatherApi.units = props.units;

		var timer = new haxe.Timer(props.update_interval * 60 * 1000);
		timer.run = function() {
			getPrediction(state, server.updateClientState, server.log.error);
		};

		return execute(state);
	}

	public function execute(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			if (currentTownIndex == -1)
				reject('Town id not found');

			getPrediction(currentState, resolve, reject);
		});
	}

	override public function onLongPress(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise((resolve, reject) -> {
			if (currentTownIndex == -1)
				reject('Town id not found');

			var length = switch typeOfSearch {
				case id: props.town_ids.length;
				case location: props.town_locations.length;
				case name: props.town_names.length;
			}
			currentTownIndex = (currentTownIndex + 1) % length;
			getPrediction(currentState, resolve, reject);
		});
	}

	function getPrediction(currentState:ItemState, resolve:ItemState->Void, reject:Any->Void) {
		function onResponse(res:WeatherResponse) {
			var time = DateTools.format(Date.now(), '%H:%M');
			var temp = Math.round(res.main.temp);
			var tempText = new RichString(temp + tempUnit).size(currentState.textSize * 2).bold();
			currentState.text = '${new RichString(res.name).underline()}\n$time $tempText';

			if (res.weather.length > 0) {
				var icon = res.weather[0].icon;
				OpenWeatherApi.getIcon(icon).then(ic -> {
					currentState.icon = Base64.encode(ic);
					resolve(currentState);
				}).catchError((e) -> {
					server.log.error('Error fetching $icon icon.');
					resolve(currentState);
				});
			} else {
				resolve(currentState);
			}
		}

		switch typeOfSearch {
			case id:
				OpenWeatherApi.getWeatherById(props.town_ids[currentTownIndex]).then(onResponse).catchError(reject);
			case location:
				OpenWeatherApi.getWeatherByLocation(props.town_locations[currentTownIndex]).then(onResponse).catchError(reject);
			case name:
				OpenWeatherApi.getWeatherByName(props.town_names[currentTownIndex]).then(onResponse).catchError(reject);
		}
	}
}
