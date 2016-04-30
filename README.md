# MainThreadGuard
Tracking UIKit access on main thread

[![CI Status](http://img.shields.io/travis/Khoa Pham/MainThreadGuard.svg?style=flat)](https://travis-ci.org/Khoa Pham/MainThreadGuard)
[![Version](https://img.shields.io/cocoapods/v/MainThreadGuard.svg?style=flat)](http://cocoapods.org/pods/MainThreadGuard)
[![License](https://img.shields.io/cocoapods/l/MainThreadGuard.svg?style=flat)](http://cocoapods.org/pods/MainThreadGuard)
[![Platform](https://img.shields.io/cocoapods/p/MainThreadGuard.svg?style=flat)](http://cocoapods.org/pods/MainThreadGuard)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Features

### Checking

- setNeedsLayout
- setNeedsDisplay
- setNeedsDisplayInRect:

Try 

```swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        view.addSubview(label)

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            label.text = "Setting text on background thread"
        }
    }
}
```

### Swizzle

This is just a Swift port of [PSPDFUIKitMainThreadGuard.m](https://gist.github.com/steipete/5664345) using swizzling on `UIView` extension

## Installation

MainThreadGuard is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MainThreadGuard"
```

## Credit
Credit goes to [PSPDFUIKitMainThreadGuard.m](https://gist.github.com/steipete/5664345)

## Author

Khoa Pham, onmyway133@gmail.com

## License

MainThreadGuard is available under the MIT license. See the LICENSE file for more info.
