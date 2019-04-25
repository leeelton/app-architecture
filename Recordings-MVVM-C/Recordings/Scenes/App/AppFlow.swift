//
//  AppFlow.swift
//  Recordings
//
//  Created by elton.lee on 4/11/19.
//

import RxSwift
import RxFlow
import RxCocoa
import UIKit

enum AppSteps: Step {
	case home
	case player(recording: Recording)
}

class AppFlow: Flow {

	var root: Presentable {
		return rootViewController
	}

	private let rootViewController = RecordingsSplitViewController()
	private let window: UIWindow

	init(window: UIWindow) {
		self.window = window
	}

	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? AppSteps else { return .none }
		switch step {
		case .home:
			return navigateToHome()
		case .player(let recording):
			return navigateToPlayer(recording: recording)
		}
	}

	private func navigateToHome() -> FlowContributors {
		let folderViewController = FolderViewController(style: .plain)
		let folderNavigationController = FolderNavigationController(rootViewController: folderViewController)
		folderViewController.navigationItem.leftItemsSupplementBackButton = true
		folderViewController.navigationItem.leftBarButtonItem = folderViewController.editButtonItem
		folderNavigationController.setupNavController()
		folderViewController.restorationIdentifier = "HomeFolderViewController"
		rootViewController.viewControllers = [folderNavigationController]
		rootViewController.setupSplitViewController()
		rootViewController.delegate = self
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()

		let folderFlow = FolderFlow(navigationController: folderNavigationController)
		return .one(flowContributor: .contribute(withNextPresentable: folderFlow, withNextStepper: folderViewController.viewModel))
	}

	private func navigateToPlayer(recording: Recording) -> FlowContributors {
		let playerViewController = PlayerViewController()
		let playerNavigationController = PlayerNavigationController(rootViewController: playerViewController)
		playerNavigationController.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		playerNavigationController.navigationBar.barTintColor = UIColor.bloo
		playerNavigationController.navigationBar.isTranslucent = false
		playerNavigationController.navigationBar.tintColor = UIColor.oranji
		playerViewController.viewModel.recording.value = recording
		playerViewController.navigationItem.leftBarButtonItem = rootViewController.displayModeButtonItem
		playerViewController.navigationItem.leftItemsSupplementBackButton = true
		rootViewController.showDetailViewController(playerNavigationController, sender: nil)
		return .none
	}

}

fileprivate extension UISplitViewController {
	func setupSplitViewController() {
		self.preferredDisplayMode = .allVisible
	}
}

fileprivate extension UINavigationController {
	func setupNavController() {
		self.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		self.navigationBar.barTintColor = UIColor.bloo
		self.navigationBar.isTranslucent = false
		self.navigationBar.tintColor = UIColor.oranji
	}
}

extension AppFlow: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let topAsDetailController = (secondaryViewController as? UINavigationController)?.topViewController as? PlayerViewController else { return false }
		if topAsDetailController.viewModel.recording.value == nil {
			// Don't include an empty player in the navigation stack when collapsed
			return true
		}
		return false
	}
}

class AppStepper: Stepper {
	let steps = PublishRelay<Step>()
	let initialStep: Step = AppSteps.home
}
