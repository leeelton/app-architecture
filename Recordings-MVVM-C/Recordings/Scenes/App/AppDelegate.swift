import UIKit
import AVFoundation
import RxFlow
import RxSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var coordinator: Coordinator? = nil

	var flowCoordinator = FlowCoordinator()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let splitViewController = UISplitViewController()
		let folderViewController = FolderViewController(style: .plain)
		let folderNavigationController = UINavigationController(rootViewController: folderViewController)
		folderNavigationController.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.white
		]
		folderNavigationController.navigationBar.barTintColor = UIColor.bloo
		folderNavigationController.navigationBar.isTranslucent = false
		folderNavigationController.navigationBar.tintColor = UIColor.oranji
		splitViewController.viewControllers = [folderNavigationController]
		splitViewController.delegate = self
		splitViewController.preferredDisplayMode = .allVisible
		coordinator = Coordinator(splitViewController)
		window?.rootViewController = splitViewController
		window?.makeKeyAndVisible()
		return true
	}

	func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
		return true
	}
	
	func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
		return true
	}
}

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let topAsDetailController = (secondaryViewController as? UINavigationController)?.topViewController as? PlayViewController else { return false }
		if topAsDetailController.viewModel.recording.value == nil {
			// Don't include an empty player in the navigation stack when collapsed
			return true
		}
		return false
	}
}
