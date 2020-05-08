# ContextMenuSwift


![License](https://img.shields.io/cocoapods/l/Hero.svg?style=flat)
![Xcode 10.0+](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg)
![iOS 10.0+](https://img.shields.io/badge/iOS-10.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)

## Installation

Just add `ContextMenuSwift` to your Podfile and `pod install`. Done!

```ruby
pod 'ContextMenuSwift'
```

## Usage 

### Example 1

<img src="/Images/example1.gif" height="520" />

Show the menu of string values on your view

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
```

### Example 2

<img src="/Images/example2.gif" height="520" />

Update menu items async

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    CM.items = ["Item 1"]
    CM.updateView()
}
```

### Example 3

<img src="/Images/example3.gif" height="520" />

Update targeted view async

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    CM.changeViewTargeted(newView: YourView)
    CM.updateView()
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
CM.showMenu(viewTargeted: YourView, delegate: self)
```
