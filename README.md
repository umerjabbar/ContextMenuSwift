# ContextMenuSwift

[![Linkedin: umerjabbar](http://img.shields.io/badge/linkedin-umerjabbar-70a1fb.svg?style=flat)](https://www.linkedin.com/in/umerjabbar)
[![Twitter: @Umer_Jabbar](http://img.shields.io/badge/twitter-%40Umer_Jabbar-70a1fb.svg?style=flat)](https://twitter.com/Umer_Jabbar)
![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)
![Xcode 10.0+](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg)
![iOS 10.0+](https://img.shields.io/badge/iOS-10.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![Cocoapods](http://img.shields.io/badge/Cocoapods-available-green.svg?style=flat)](https://cocoapods.org/pods/ContextMenuSwift)

## Installation 📱

Just add `ContextMenuSwift` to your Podfile and `pod install`. Done!

```ruby
pod 'ContextMenuSwift'
```

## Usage ✨ 

### Example 1

<img src="/Images/example1.gif" height="520" />

Show the menu of string values on your view

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self, animated: true)
```

### Example 2

<img src="/Images/example2.gif" height="520" />

Update menu items async

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self, animated: true)
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    CM.items = ["Item 1"]
    CM.updateView(animated: true)
}
```

### Example 3

<img src="/Images/example3.gif" height="520" />

Update targeted view async

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self, animated: true)
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    CM.changeViewTargeted(newView: YourView)
    CM.updateView(animated: true)
}
```

### Example 4

<img src="/Images/menu_with_icons.jpeg" height="520" />

Show menu with icons

```swift
let share = ContextMenuItemWithImage(title: "Share", image: #imageLiteral(resourceName: "icons8-upload"))
let edit = "Edit"
let delete = ContextMenuItemWithImage(title: "Delete", image: #imageLiteral(resourceName: "icons8-trash"))
CM.items = [share, edit, delete]
CM.showMenu(viewTargeted: YourView, delegate: self, animated: true)
```

### Delegate

You can check events by implement ContextMenuDelegate
```swift
extension ViewController : ContextMenuDelegate {
    
    func contextMenu(_ contextMenu: ContextMenu, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
        print(item.title)
        return true //should dismiss on tap
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
    }
 
}
```

## Requirements

* Xcode 9+
* Swift 4.0
* iOS 10+

## License

This project is under MIT license. For more information, see `LICENSE` file.

## Credits 

ContextMenuSwift was developed while trying to implement iOS 13 context menu with a tap gesture.


It will be updated when necessary and fixes will be done as soon as discovered to keep it up to date.

You can find me on Twitter [@Umer_Jabbar](https://twitter.com/Umer_Jabbar) and Linkedin [umerjabbar](https://www.linkedin.com/in/umerjabbar/).

Enjoy! 🤓
