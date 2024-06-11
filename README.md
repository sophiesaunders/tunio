# Tunio

Tunio is a simple audio tuner that works with any instrument (I've tried on flute, voice, guitar, and ukulele so far), on both macOS and iOS. 

This project is certainly still a work in progress, so stay tuned for more upcoming changes. 

## What this project utilizes:

- AudioKit: https://github.com/AudioKit/AudioKit
- AudioKit CookBook: https://github.com/AudioKit/Cookbook (see the Tuner mini-app)
- AVFoundation: https://developer.apple.com/av-foundation/
- SwiftUI: https://developer.apple.com/documentation/swiftui
- Xcode: Version 15.4
- Swift: Version 5

## Things I've learned along the way:

1. Nothing is guaranteed to work on both macOS and iOS, and most tuner apps are iOS only. Anything starting with "UI" is likely iOS only. AVAudioSession is also iOS only.
2. To get microphone input working (project-settings-wise): a) Add "NSMicrophoneUsageDescription" to the info.plist (or, if you're using a newer Xcode version that doesn't give you an info.plist, go into the project -> target -> "Info" tab and then the Custom Target Properties. It needs to contain a string that explains to the user why you need their microphone. b) Go into project -> target -> "Signing & Capabilities" tab -> App Sandbox -> Check the "Audio Input" box.
3. To add an item to the "Info" tab (that replaces the physical info.plist), just right click on the existing list and then do "Add Row".
4. To add a package dependency, go to File -> Add Package Dependencies, then click the "+" on the bottom left, and provide the link to the package index. Once loaded, you'll see a list of packages you can choose between, then select one and click "Add Package".
5. SOUND MIGHT JUST NOT WORK EVER ON THE SIMULATOR. Others are having this problem too with iOS 17+, the app is working on my actual phone but not the iOS simulator.
6. SwiftUI is the newer, swift-ier version of UIKit. A lot of tutorials are for UIKit which are only partially relevant.

## To Do List

### Short-term: Tuner
- Add an app icon and a logo.
- Update to matching color scheme.
- Test: Make sure iOS doesn't freeze anymore after sitting in background.

### Long-term: Brainstorm
- Add a sustained note mode (user selects the note, the app plays a tone).
- Add a metronome mode (user selects bpm and optionally number of beats per measure).
- Add walkthrough mode for string instruments (guitar, ukulele) where it walks you through tuning each string in order and goes to the next once each one is in-tune.
- Add unit tests.
