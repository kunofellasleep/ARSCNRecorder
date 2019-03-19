# ARSCNRecorder

[![CI Status](https://img.shields.io/travis/kunofellasleep/ARSCNRecorder.svg?style=flat)](https://travis-ci.org/kunofellasleep/ARSCNRecorder)
[![Version](https://img.shields.io/cocoapods/v/ARSCNRecorder.svg?style=flat)](https://cocoapods.org/pods/ARSCNRecorder)
[![License](https://img.shields.io/cocoapods/l/ARSCNRecorder.svg?style=flat)](https://cocoapods.org/pods/ARSCNRecorder)
[![Platform](https://img.shields.io/cocoapods/p/ARSCNRecorder.svg?style=flat)](https://cocoapods.org/pods/ARSCNRecorder)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 11.0+

## Installation

**CocoaPods (iOS 11.0+)**

You can use CocoaPods to install ARSCNRecorder by adding it to your Podfile:

```ruby
platform :ios, '11.0'
use_frameworks!

target 'MyApp' do
    pod 'ARSCNRecorder'
end
```
## Usage

**Initialization**

```Swift
import SwiftyJSON
```

```Swift
let recorder = ARSCNRecorder()
sceneView.delegate = recorder
```

```plist:info.plist
<key>NSCameraUsageDescription</key>
<string>...</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>...</string>
```

**Start Recording**

```Swift
recorder.startRecording(sceneView, ARSCNRecorderOptions())
```

**Finish Recording**

```Swift
recorder.finishRecording(isSaveLibrary: true) { videoUrl in
	print(videoUrl!)
}
```

## License

ARSCNRecorder is available under the MIT license. See the LICENSE file for more info.
