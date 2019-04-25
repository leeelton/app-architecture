import UIKit
import AVFoundation
import RxFlow
import RxSwift
import RxCocoa


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var flowCoordinator = FlowCoordinator()
	let disposeBag = DisposeBag()

	var didDecodeRestorableState: Bool = false

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		guard let window = window else { return false }
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

	func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
		print ("\(identifierComponents.last ?? "None")")
		return nil
	}
}
