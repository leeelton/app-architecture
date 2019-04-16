import UIKit
import AVFoundation
import RxFlow
import RxSwift
import RxCocoa


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var coordinator: Coordinator? = nil

	var flowCoordinator = FlowCoordinator()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		guard let window = window else { return false }
//
//		let splitViewController = UISplitViewController()
//		let folderViewController = FolderViewController(style: .plain)
//		let folderNavigationController = UINavigationController(rootViewController: folderViewController)
//		folderNavigationController.navigationBar.titleTextAttributes = [
//			NSAttributedString.Key.foregroundColor: UIColor.white
//		]
//		folderNavigationController.navigationBar.barTintColor = UIColor.bloo
//		folderNavigationController.navigationBar.isTranslucent = false
//		folderNavigationController.navigationBar.tintColor = UIColor.oranji
//		splitViewController.viewControllers = [folderNavigationController]
//		splitViewController.delegate = self
//		splitViewController.preferredDisplayMode = .allVisible
//		coordinator = Coordinator(splitViewController)

		let appFlow = AppFlow(window: window)
		flowCoordinator.coordinate(flow: appFlow, with: AppStepper())
		return true
	}

	func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return true
	}
	
	func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return true
	}
}
