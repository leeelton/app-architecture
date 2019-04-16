//
//  AppFlow.swift
//  Recordings
//
//  Created by elton.lee on 4/11/19.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa
import UIKit

class AppFlow: Flow {

	var root: Presentable {
		return rootViewController
	}

	private lazy var rootViewController: UISplitViewController = {
		let splitViewController = UISplitViewController()
		let folderViewController = FolderViewController(style: .plain)
		let folderNavigationController = UINavigationController(rootViewController: folderViewController)
		folderNavigationController.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		splitViewController.viewControllers = [folderNavigationController]
		return splitViewController
	}()

	private var window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? AppSteps else { return .none }
		switch step {
		case .home:
			return navigateToFolder()
		}
	}

	private func navigateToFolder() -> FlowContributors {
		guard let folderViewController = rootViewController.children.first as? FolderViewController else { return .none }
		rootViewController.delegate = self
		rootViewController.preferredDisplayMode = .allVisible
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()

		return .one(flowContributor: .contribute(withNextPresentable: folderViewController, withNextStepper: folderViewController.viewModel))
	}

}

extension AppFlow: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let topAsDetailController = (secondaryViewController as? UINavigationController)?.topViewController as? PlayViewController else { return false }
		if topAsDetailController.viewModel.recording.value == nil {
			// Don't include an empty player in the navigation stack when collapsed
			return true
		}
		return false
	}
}

enum AppSteps: Step {
	case home
}

class AppStepper: Stepper {
	let steps = PublishRelay<Step>()

	init() {
		steps.accept(AppSteps.home)
	}

}
