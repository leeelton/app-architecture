//
//  RecordingsSplitViewController.swift
//  Recordings
//
//  Created by elton.lee on 4/23/19.
//

import UIKit

class RecordingsSplitViewController: UISplitViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		restorationIdentifier = className
	}

	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
	}

	override func decodeRestorableState(with coder: NSCoder) {
	}
}

extension RecordingsSplitViewController: UIViewControllerRestoration {
	public static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
		let splitViewController = UISplitViewController()
		splitViewController.restorationIdentifier = identifierComponents.last
		return splitViewController
	}
}
