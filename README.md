<p align="center" >
<img src="https://engagingchoice-qa.kiwireader.com/static/img/logo%402x.png" title="Engaging Choice logo" float=left>
</p>


# EngagingChoice

[![CI Status](https://img.shields.io/travis/shahwalkhan@gmail.com/EngagingChoice.svg?style=flat)](https://travis-ci.org/shahwalkhan@gmail.com/EngagingChoice)
[![Version](https://img.shields.io/cocoapods/v/EngagingChoice.svg?style=flat)](https://cocoapods.org/pods/EngagingChoice)
[![License](https://img.shields.io/cocoapods/l/EngagingChoice.svg?style=flat)](https://cocoapods.org/pods/EngagingChoice)
[![Platform](https://img.shields.io/cocoapods/p/EngagingChoice.svg?style=flat)](https://cocoapods.org/pods/EngagingChoice)

This library provides a ECGridView to show MediaContent and ECPoweredByView to show Engaging Choice icon. For convenience, we make subClass for view 

Features

Class for ECGridView
Class for ECPoweredByView to show Engaging Choice icon
ECMediaContentManager is singletone class and will use for getting media content data and content detail
ECGridManager is singletone class and will use to provide secret key

## Requirements

- iOS 11.0 or later
- Xcode 9.4.1 or later

# How To Use

NOTE: You must provide a description and key NSLocationWhenInUseUsageDescription in your app's Info.plist file.

ECGridManager
```swift
import FabricSell

ECGridManager.shared.config(secretKey: "SECRET_KEY") 
```
Replace SECRET_KEY with  publisher secret key

ECMediaContent
```swift
import FabricSell

ECMediaContentManager.shared.contentList(offset: 0, limit: 10) { (mediaContent) in
// Get response here
}
```
Offset and limit are optional but you can use these fields for pagination by passing offset and limit in param.

And you need to call below method to get detail of mediaContent and it's required method to call for content detail
```swift
import FabricSell

ECMediaContentManager.shared.contentDetail(contentId: MEDIA_CONTENT_ID) { (conent) in
// Get Media Content detail
}
``

ECGridView uses
```swift
import FabricSell

cell.coverImageView.setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"))

OR

cell.gridView.coverImageView.sd_setImage(with: url, placeholderImage: UIImage(name: "http://www.domain.com/path/to/image.jpg"), completed: nil)

OR

cell.gridView.coverImageView.image = UIImage(name: "FILE_NAME")

- ECPoweredByView uses

let poweredByView = ECPoweredByView(frame: CGRect(x: 0, y: 0, width: 245, height: 23))
self.view.addSubview(poweredByView)
```
OR
ECPoweredByView can also used from storyboard by draging UIView in UIViewController and give a class ECPoweredByView




## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FabricSell is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod 'EngagingChoice'
```

## Author

EngagingChoice, gitforengaging@gmail.com

## License

EngagingChoice is available under the MIT license. See the LICENSE file for more info.
