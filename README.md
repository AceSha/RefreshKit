# RefreshKit

[![CI Status](http://img.shields.io/travis/81556205@qq.com/RefreshKit.svg?style=flat)](https://travis-ci.org/81556205@qq.com/RefreshKit)
[![Version](https://img.shields.io/cocoapods/v/RefreshKit.svg?style=flat)](http://cocoapods.org/pods/RefreshKit)
[![License](https://img.shields.io/cocoapods/l/RefreshKit.svg?style=flat)](http://cocoapods.org/pods/RefreshKit)
[![Platform](https://img.shields.io/cocoapods/p/RefreshKit.svg?style=flat)](http://cocoapods.org/pods/RefreshKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

swift 3.0, iOS 8.0+

## Installation

RefreshKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RefreshKit'
```

## Usage
你可以简单的使用或者设置默认的刷新头（尾）如下

```
tableView.refresh
         .header
         .configure { h in
             // configure
          }
         .addAction { _ in 
             //code
        }
// 开始刷新
tableView.refresh
         .header
         .beginRefreshing()
// 结束刷新
tableView.refresh
         .header
         .endRefreshing()
// 尾部一个示例
tableView.refresh
         .footer
         .beginRefreshing()
         
```

或者设置自定义的刷新头或尾

```
// 只需要CustomView遵循Refreshable协议， 实现协议方法即可
class CustomView: UIView, Refreshable {
    func animationForState(state: RefreshState) {
        switch state {
        case .initial:
            print("initail")
        default:
            break
        }
    }
}

//设置如下：
let ch = CustomView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
tableView.refresh
         .setHeadher(ch)
         .addAction {
             print("refreshing")
        }
```

更多默认的刷新设置：

```
//主题色， 默认.lightGray
.tintColorForDefaultRefreshView = .black
//触发刷新的高度, 默认为视图高度
.fireHeight = 80
//各个状态的文字描述
.dictForDefaultRefreshView: [RefreshStateStringKey: String] = [:]

```


同时， Refreshable  协议也有2个可选方法

```
//同 设置触发高度，如不实现，默认为自定义视图的高度
func fireHeight() -> CGFloat
// 刷新结束后的停留时间，用于实现信息提示
func finishedStayDuration() -> TimeInterval
```

当你使用默认刷新视图时，还有一个辅助方法, 并且你可以这样使用：

```
func endRefreshingWithMessage(msg: String, delay: TimeInterval)

tableView.refresh
        .header
        .endRefreshingWithMessage(msg: "刷新失败😒", delay: 2)
        

```

## Author

81556205@qq.com

## License

RefreshKit is available under the MIT license. See the LICENSE file for more info.
