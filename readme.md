# Action for ideckia: open-weather

## Definition

Show the weather in the given towns (can be by id, name or latitude and longitude).

## Properties

| Name | Type | Default | Description | Possible values |
| ----- |----- | ----- | ----- | ----- |
| open_weather_key | String | null | OpenWeather API key (get it [here](https://openweathermap.org/appid)) | null |
| town_ids | Array&lt;UInt&gt; | [] | OpenWeather town id array (get the IDs [here](https://openweathermap.org/current#cityid)) | null |
| town_locations | Array&lt;{ lon : Float, lat : Float }&gt; | [] | Towns Locations array (latitude and longitude values). | null |
| town_names | Array&lt;String&gt; | [] | Towns names array. | null |
| units | String | 'metric' | Units of measurement | [standard,metric,imperial] |
| update_interval | UInt | 15 | Update interval in minutes | null |
| language | String | 'en' | Which language do you want the description | [af (Afrikaans),al (Albanian),ar (Arabic),az (Azerbaijani),bg (Bulgarian),ca (Catalan),cz (Czech),da (Danish),de (German),el (Greek),en (English),eu (Basque),fa (Persian (Farsi)),fi (Finnish),fr (French),gl (Galician),he (Hebrew),hi (Hindi),hr (Croatian),hu (Hungarian),id (Indonesian),it (Italian),ja (Japanese),kr (Korean),la (Latvian),lt (Lithuanian),mk (Macedonian),no (Norwegian),nl (Dutch),pl (Polish),pt (Portuguese),pt_br (Português Brasil),ro (Romanian),ru (Russian),sv (Swedish),sk (Slovak),sl (Slovenian),es (Spanish),sr (Serbian),th (Thai),tr (Turkish),uk (Ukrainian),vi (Vietnamese),zh_cn (Chinese Simplified),zh_tw (Chinese Traditional),zu (Zulu)] |

## On single click

Updates current town weather

## On long press

Shows next town weather

## Example in layout file

```json
{
    "state": {
        "text": "open-weather action example",
        "actions": [
            {
                "name": "open-weather",
                "props": {
                    "language": "eu",
                    "open_weather_key": null,
                    "town_ids": [],
                    "town_locations": [],
                    "town_names": [],
                    "units": "metric",
                    "update_interval": 15
                }
            }
        ]
    }
}
```