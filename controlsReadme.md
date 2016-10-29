# Controls Docs

## Resources

Spotify track info - [API info here](https://developer.spotify.com/web-api/get-track/)

## iOS Client API

### Playback screen

`backBroadcast()` - tells all devices to go back one song

`fowardBroadcast()` - tells all devices to go forward one song

`playBroadcast()` - play

`pauseBroadcast()` - pause

`setVolume()` - change self volume

`play(time interval)` - takes 

## iOS Host API

### Editing screen

By default, each device starts off playing at full volume for the entire duration of the song

`addIntervals(songID, deviceID, [intervals])` 

`startBroadcast()`  -  for each device, send intervals[device] to device, then call `playBroadcast()` to begin simultaneously
