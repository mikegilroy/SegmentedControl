# SegmentedControl
A custom animated segmented control 

## Demo
![](https://raw.githubusercontent.com/mikegilroy/SegmentedControl/master/segmented-control-demo.gif)

## Installation
Download the SegmentedControl.swift file and add it into your own project

## Usage
```swift
class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSegmentedControl()
  }
	
  func setupSegmentedControl() {
    let segmentedControl = SegmentedControl(frame: CGRect(x:0, y:0, width: 200, height: 45), tabIcons: [UIImage(named: "beer_icon"), UIImage(named: "bar_icon"), UIImage(named: "night_club"), UIImage(named: "restaurant")], controlColor:   UIColor.orange, selectedTabColor: UIColor.white, tabTintColor: UIColor.white)
    segmentedControl.delegate = self
    view.addSubview(segmentedControl)
  }

}

extension ViewController: SegmentedControlDelegate {
	
	func tabSelected(atIndex index: Int) {
		print("Selected tab at index \(index)")
	}
}
```
