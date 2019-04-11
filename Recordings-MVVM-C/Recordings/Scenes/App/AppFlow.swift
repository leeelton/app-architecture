//
//  AppFlow.swift
//  Recordings
//
//  Created by elton.lee on 4/11/19.
//

import Foundation
import RxSwift
import RxFlow
import UIKit

class AppFlow: Flow {

	var root: Presentable {
		return rootViewController
	}

	private lazy var rootViewController: UISplitViewController = {
		let splitViewController = UISplitViewController()
		splitViewController.loadViewIfNeeded()
		return splitViewController
	}()

	func navigate(to step: Step) -> FlowContributors {
		return .none
	}


}
