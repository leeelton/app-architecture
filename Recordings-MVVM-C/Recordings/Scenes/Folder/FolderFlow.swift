//
//  FolderCoordinator.swift
//  Recordings
//
//  Created by elton.lee on 4/9/19.
//

import UIKit
import RxSwift
import RxFlow

enum FolderStep: Step {
	case folder(initialFolder: Folder)
	case recording(_ recording: Recording)
}

final class FolderFlow: Flow {

	var root: Presentable {
		return rootViewController
	}

	let rootViewController: UINavigationController

	init(navigationController: UINavigationController) {
		rootViewController = navigationController
	}

	func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? FolderStep else { return .none }
		switch step {
		case .folder(let initialFolder):
			let folderViewController = FolderViewController(style: .grouped)
			folderViewController.viewModel = FolderViewModel(initialFolder: initialFolder)
			rootViewController.pushViewController(folderViewController, animated: true)
			return .one(flowContributor: .contribute(withNextPresentable: folderViewController, withNextStepper: folderViewController.viewModel))
		case .recording(let recording):
			return .one(flowContributor: .forwardToParentFlow(withStep: AppSteps.player(recording: recording)))
		}
	}
}
