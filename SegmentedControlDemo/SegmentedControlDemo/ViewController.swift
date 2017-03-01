//
//  ViewController.swift
//  SegmentedControlDemo
//
//  Created by Mike Gilroy on 01/03/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var controlContainerView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupSegmentedControl()
	}
	
	func setupSegmentedControl() {
		let segmentedControl = SegmentedControl(frame: controlContainerView.bounds, tabIcons: [#imageLiteral(resourceName: "beer_icon"), #imageLiteral(resourceName: "bar_icon"), #imageLiteral(resourceName: "night_club"), #imageLiteral(resourceName: "restaurant")], controlColor: UIColor.orange, selectedTabColor: UIColor.white, tabTintColor: UIColor.white, startingIndex: 2)
		segmentedControl.delegate = self
		controlContainerView.addSubview(segmentedControl)
	}
}

extension ViewController: SegmentedControlDelegate {
	
	func tabSelected(atIndex index: Int) {
		
		messageLabel.alpha = 1
		messageLabel.text = "You selected tab number \(index + 1) ☝️"
		UIView.animate(withDuration: 1, delay: 1, options: .curveEaseInOut, animations: {
			self.messageLabel.alpha = 0
		})
	}
}

