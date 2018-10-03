# Open-Weather-Map-API
App that shows you the weather based on your current location.

<img src="https://github.com/ajvelo/Open-Weather-Map-API/blob/master/screen%20shot.png" width="250" height="425"/>


### How it works

When initially opened the app first checks for internet connectivity. If it fails, a cached weather data is retrieved (provided the cache is less than 24 hours old). If there is no cache. A label appears telling the user there is no internet connection.

Should the app succeed to connect, it first asks the user for permission to use their location. If the user refuses, the same process mentioned prior is executed, although the label this time displays the location could not be found.

If the user is connected and they agree to share their location, a request to the OpenWeatherMapAPI is executed, with the user's latitude, longitude and API key as the parameters. If this succeeds, then the weather data is saved using Core Data and the information is displayed on screen as shown in the image. Should the API call fail, the same fail process mentioned in the prior scenarios is carried out.

A refresh button is also provided that resends another request to the API, refreshing the view if successful.

### Why it works

The local data is stored using Core Data. When loading, the information between the weather data model and the view is parsed using a struct that contains all the necessary information to display to the user. The process is reciprocated when saving.

Caches more than 24 hours old are deleted. The check for this is done when all app activity terminates.

### Advantages

Careful consideration was made to ensure the attributes of the model were of the same type. Only once the information was parsed did types change to be displayed on the view correctly. E.g dates were changed to string and the redundant information was removed so a date of EEEE, MMM d, yyyy could be displayed.

The view was simple and relatively straightforward. If a more complex view was needed the UI would likely have been done programatically.

### Improvements

For larger applications requires more API calls, better file seperation would be needed, since the request does not need to sit in the ViewController and instead could have it's own layer.

Sending the request in the location manager delegate means it's called multiple times, although when loading from cache, only the first is retrieved. If concerned about the number of API requests or a limit is imposed it would be better to have the call function placed somewhere where it is only called once, maybe using a Bool.
