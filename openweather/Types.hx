package openweather;

typedef WeatherResponse = {
	var ?coord:{
		var ?lon:Float;
		var ?lat:Float;
	};
	var ?weather:Array<{
		var ?id:Int;
		var ?main:String;
		var ?description:String;
		var ?icon:String;
	}>;
	var ?base:String;
	var ?main:{
		var ?temp:Float;
		var ?feels_like:Float;
		var ?temp_min:Float;
		var ?temp_max:Float;
		var ?pressure:Int;
		var ?humidity:Int;
		var ?sea_level:Int;
		var ?grnd_level:Int;
	};
	var ?visibility:Int;
	var ?wind:{
		var ?speed:Float;
		var ?deg:Int;
		var ?gust:Float;
	};
	var ?clouds:{
		var ?all:Int;
	};
	var ?dt:Int;
	var ?sys:{
		var ?type:Int;
		var ?id:Int;
		var ?country:String;
		var ?sunrise:Int;
		var ?sunset:Int;
	};
	var ?timezone:Int;
	var ?id:Int;
	var ?name:String;
	var ?cod:Int;
}
