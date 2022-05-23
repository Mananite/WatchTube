WatchTube is a standalone WatchOS YouTube player using [Invidious](https://invidious.io) for metadata and [YouTubeKit](https://github.com/alexeichhorn/YouTubeKit) for streaming. The app is based off of [Ziph0n's original Wristplayer](https://github.com/Ziph0n/WristPlayer) and is a fork of [akissu's youtubedl-watchos](https://github.com/akissu/youtubedl-watchos).

Features:

1. The app fully relies on [Invidious](https://invidious.io) to avoid using the official YouTube API.

2. Doesn't require a YouTube API Key

3. Free alternative to other apps on the App Store, as we believe in open-source software

4. Curated recommendations and subscriptions to channels


# Installing
[Open in TestFlight](https://testflight.apple.com/join/tpwIQJIR)

# Building from source

0. OPTIONAL: Star this repo :)
1. Clone the repo to any location to open in Xcode
2. Open the xcodeproj file or open Xcode and open existing project
3. Replace all of the signing and team identifiers in Xcode
> Replace the bundle ID for all 3 targets with something unique. Don't forget to replace bundle ID in the `info.plist` file in the watchkit extension folder. Expand NSExtension and expand NSExtensionAttributes to find WKAppBundleIdentifier.
Make sure you add your Apple ID to Xcode or else your personal team will not appear.
4. Build and deploy WatchOS app
> Plug your iPhone into your Mac and it should start preparing both devices for development.
> We've had plenty of people have their Xcode progress stuck on "Running WatchTube". If this happens to you, make sure Xcode isn't installing any device support. If it is, wait. If not, restart Xcode and run the app again.
5. Exhale 😮‍💨
# Demonstrations

Using v1.0.4

![](./demo/1.gif)
> Note that this is a demonstration of the simulator. The video playback controls were odd and the videos look long to load. This is not a problem on real devices.
Using uncompleted development build of v1.2.2

![](./demo/2.gif)
> Note that this is a demonstration of the simulator. This is an unfinished build of 1.2.2. I thought I should share to new viewers of this readme what WatchTube can really do! Also, I recorded this in school on mobile hotspot, so some things take time to load.
More demonstrations coming soon!
