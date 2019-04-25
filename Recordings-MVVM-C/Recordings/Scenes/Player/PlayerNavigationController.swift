//
//  PlayerNavigationController.swift
//  Recordings
//
//  Created by elton.lee on 4/23/19.
//

import UIKit

class PlayerNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		restorationIdentifier = className
//		restorationClass = PlayerNavigationController.self
	}

	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
	}

	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
	}
}

extension PlayerNavigationController: UIViewControllerRestoration {
	static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
		let playerNavController = PlayerNavigationController()
		playerNavController.restorationIdentifier = identifierComponents.last
//		playerNavController.restorationClass = PlayerNavigationController.self
		return playerNavController
	}
}
