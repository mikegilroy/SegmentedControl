//
//  SegmentedControl.swift
//  SegmentedControlDemo
//
//  Created by Mike Gilroy on 01/03/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit

public protocol SegmentedControlDelegate: class {
	func tabSelected(atIndex index: Int)
}

public class SegmentedControl: UIView {
	
	// MARK: - Properties
	
	weak var delegate: SegmentedControlDelegate?
	
	/// Images to be used for tab icons. Image icons must have transparency in order for selected tab background to show as intended.
	private var tabIcons: [UIImage] = []
	private(set) var tabs: [UIImageView] = []
	
	// MARK: Tab Selection
	private(set) var selectedIndex: Int = 0
	private(set) var selectedTab: UIImageView = UIImageView()
	private var startingIndex = 0
	
	// MARK: UI
	var controlColor = UIColor.orange {
		willSet(newColor) {
			self.backgroundColor = newColor
			self.shadowLayer?.fillColor = newColor.cgColor
		}
	}
	
	var tabTintColor = UIColor.orange {
		willSet(newColor) {
			for tab in tabs where tab != selectedTab {
				tab.tintColor = newColor
			}
		}
	}
	
	var selectedTabColor = UIColor.white {
		willSet(newColor) {
			selectedTabBackgroundView.backgroundColor = newColor
			selectedTabShadowLayer?.fillColor = newColor.cgColor
		}
	}
	
	var animationDuration: TimeInterval = 0.25
	private var margin: CGFloat = 6
	private var spacing: CGFloat = 6
	private var imagePadding: CGFloat = 4
	private var selectedTabBackgroundView: UIView = UIView()
	private var shadowLayer: CAShapeLayer?
	private var selectedTabShadowLayer: CAShapeLayer?
	
	private var tabWidth : CGFloat {
		return (self.frame.width - (margin * 2) - (spacing * CGFloat(tabIcons.count - 1))) / CGFloat(tabIcons.count)
	}
	
	private var tabHeight : CGFloat {
		return self.frame.height - (margin * 2)
	}
	
	
	// MARK: - Initialisers
	
	convenience init() {
		self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	init(frame: CGRect, tabIcons: [UIImage], controlColor: UIColor, selectedTabColor: UIColor, tabTintColor: UIColor, startingIndex: Int = 0) {
		
		// Check width is enough to fit tabs at smallest size ratio of 1:1 (circles)
		let tabHeight = frame.height - (imagePadding * 2)
		let minWidth = (CGFloat(tabIcons.count) * tabHeight) + (CGFloat(tabIcons.count - 1) * spacing) + (margin * 2)
		if frame.width < minWidth {
			super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: minWidth, height: frame.height))
		} else {
			super.init(frame: frame)
		}
		
		self.tabIcons = tabIcons
		self.controlColor = controlColor
		self.selectedTabColor = selectedTabColor
		self.tabTintColor = tabTintColor
		if startingIndex != 0 {
			self.startingIndex = startingIndex
			self.selectedIndex = startingIndex
		}
		
		commonInit()
	}
	
	private func commonInit() {
		setupViews()
		addShadow()
	}
	
	
	// MARK: - Setup
	
	private func setupViews() {
		self.backgroundColor = controlColor
		self.layer.cornerRadius = self.frame.height / 2
		
		let selectedTabBackgroundView = UIView(frame: CGRect(x: margin + (CGFloat(startingIndex) * (spacing + tabWidth)), y: margin, width: tabWidth, height: tabHeight))
		selectedTabBackgroundView.backgroundColor = selectedTabColor
		selectedTabBackgroundView.layer.cornerRadius = tabHeight / 2
		self.selectedTabBackgroundView = selectedTabBackgroundView
		addSubview(selectedTabBackgroundView)
		
		for (index, tabIcon) in tabIcons.enumerated() {
			let templateIcon = tabIcon.withRenderingMode(.alwaysTemplate)
			let tabImageView = UIImageView(image: templateIcon)
			let x =  margin + ((tabWidth + spacing) * CGFloat(index))
			tabImageView.frame = CGRect(x: x, y: margin + imagePadding, width: tabWidth, height: tabHeight - (imagePadding * 2))
			
			tabImageView.clipsToBounds = true
			tabImageView.contentMode = .scaleAspectFit
			tabImageView.layer.cornerRadius = tabHeight / 2
			if index == startingIndex {
				tabImageView.tintColor = backgroundColor
			} else {
				tabImageView.tintColor = tabTintColor
			}
			tabImageView.tag = index
			
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedTab(sender:)))
			let tappableFrame = CGRect(x: tabImageView.frame.origin.x, y: 0, width: tabImageView.frame.width, height: self.frame.height)
			let imageGestureView = UIView(frame: tappableFrame)
			imageGestureView.backgroundColor = UIColor.clear
			imageGestureView.addGestureRecognizer(tapGesture)
			imageGestureView.isUserInteractionEnabled = true
			imageGestureView.tag = index
			
			tabs.append(tabImageView)
			addSubview(tabImageView)
			addSubview(imageGestureView)
		}
	}
	
	private func addShadow() {
		if shadowLayer == nil {
			// Segmented Control Shadow
			let shadowLayer = CAShapeLayer()
			shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2).cgPath
			shadowLayer.fillColor = controlColor.cgColor
			
			shadowLayer.shadowColor = UIColor.darkGray.cgColor
			shadowLayer.shadowPath = shadowLayer.path
			shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
			shadowLayer.shadowOpacity = 0.8
			shadowLayer.shadowRadius = 1
			self.shadowLayer = shadowLayer
			layer.insertSublayer(shadowLayer, at: 0)
			
			// Selected Tab Shadow
			let tabShadowLayer = CAShapeLayer()
			tabShadowLayer.path = UIBezierPath(roundedRect: selectedTabBackgroundView.bounds, cornerRadius: selectedTabBackgroundView.frame.height / 2).cgPath
			tabShadowLayer.fillColor = selectedTabColor.cgColor
			tabShadowLayer.shadowColor = UIColor.darkGray.cgColor
			tabShadowLayer.shadowPath = tabShadowLayer.path
			tabShadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
			tabShadowLayer.shadowOpacity = 0.5
			tabShadowLayer.shadowRadius = 1
			self.selectedTabShadowLayer = tabShadowLayer
			selectedTabBackgroundView.layer.insertSublayer(tabShadowLayer, at: 0)
		}
	}
	
	
	// MARK: - Actions
	
	@objc private func selectedTab(sender: UITapGestureRecognizer) {
		guard let selectedTab = sender.view else { return }
		let tabIndex = selectedTab.tag
		for case let tab in tabs where tab.tag == tabIndex {
			self.selectedTab = tab
		}
		if selectedIndex != tabIndex {
			for case let imageView as UIImageView in subviews  {
				imageView.tintColor = tabTintColor
			}
			DispatchQueue.main.async {
				self.selectedTab.tintColor = self.backgroundColor
				self.animateSelection(forIndex: tabIndex)
			}
			
			delegate?.tabSelected(atIndex: tabIndex)
			selectedIndex = tabIndex
		}
	}
	
	
	// MARK: - Animation
	
	private func animateSelection(forIndex index: Int) {
		let newTabX = margin + ((tabWidth + spacing) * CGFloat(index))
		
		UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			self.selectedTabBackgroundView.frame.origin.x = newTabX
		}, completion: nil)
	}
	
}
