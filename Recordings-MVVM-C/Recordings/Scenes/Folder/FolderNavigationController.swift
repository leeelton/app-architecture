//
//  FolderNavigationController.swift
//  Recordings
//
//  Created by elton.lee on 4/23/19.
//

import UIKit

class FolderNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		restorationIdentifier = className
	}
}

extension FolderNavigationController: UIViewControllerRestoration {
	static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
		let folderNavController = FolderNavigationController()
		folderNavController.restorationIdentifier = identifierComponents.last
		return folderNavController
	}
}
