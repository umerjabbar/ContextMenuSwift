# ContextMenuSwift

## Installation

Just add `ContextMenuSwift` to your Podfile and `pod install`. Done!

```ruby
pod 'ContextMenuSwift'
```

## Usage

<img src="/Images/example1.gif" />

Show the menu of string values on your view

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
```

Update menu items

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
CM.items = ["Item 1"]
CM.updateView()
```

Update targeted view 

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
CM.changeViewTargeted(newView: YourView)
CM.updateView()
```
