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


<img src="/Images/example2.gif" />

Update menu items async

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    CM.items = ["Item 1"]
    CM.updateView()
}
```


<img src="/Images/example3.gif" />

Update targeted view async

```swift
CM.items = ["Item 1", "Item 2", "Item 3"]
CM.showMenu(viewTargeted: YourView, delegate: self)
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    CM.changeViewTargeted(newView: YourView)
    CM.updateView()
}
```
