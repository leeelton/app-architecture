import UIKit

final class Coordinator {
	let splitViewController: UISplitViewController
	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	
	var folderNavigationController: UINavigationController {
		return splitViewController.viewControllers[0] as! UINavigationController
	}
	
	init(_ splitView: UISplitViewController) {
		self.splitViewController = splitView
		self.splitViewController.loadViewIfNeeded()
		
		let folderVC = folderNavigationController.viewControllers.first as! FolderViewController
		folderVC.delegate = self
		folderVC.viewModel.folder.value = Store.shared.rootFolder
		folderVC.navigationItem.leftItemsSupplementBackButton = true
		folderVC.navigationItem.leftBarButtonItem = folderVC.editButtonItem
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: Store.changedNotification, object: nil)
	}
	
	@objc func handleChangeNotification(_ notification: Notification) {
		guard let folder = notification.object as? Folder,
			notification.userInfo?[Item.changeReasonKey] as? String == Item.removed
		else { return }
		updateForRemoval(of: folder)
	}
	
	func updateForRemoval(of folder: Folder) {
		let folderVCs = folderNavigationController.viewControllers as! [FolderViewController]
		guard let index = folderVCs.firstIndex(where: { $0.viewModel.folder.value === folder }) else { return }
		let previousIndex = index > 0 ? index - 1 : index
		folderNavigationController.popToViewController(folderVCs[previousIndex], animated: true)
	}
}

extension Coordinator: FolderViewControllerDelegate {
	func didSelect(_ item: Item) {
		switch item {
		case let recording as Recording:
			let playerNC = storyboard.instantiatePlayerNavigationController(with: recording, leftBarButtonItem: splitViewController.displayModeButtonItem)
			splitViewController.showDetailViewController(playerNC, sender: self)
		case let folder as Folder:
			let folderVC = FolderViewController(style: .plain)
			folderVC.delegate = self
			folderVC.viewModel = FolderViewModel(initialFolder: folder)
			folderVC.navigationItem.leftItemsSupplementBackButton = true
			folderVC.navigationItem.leftBarButtonItem = folderVC.editButtonItem
			folderNavigationController.pushViewController(folderVC, animated: true)
		default: fatalError()
		}
	}
	
	func createRecording(in folder: Folder) {
		let recordVC = RecordViewController()
		recordVC.delegate = self
		recordVC.viewModel.folder = folder
		recordVC.modalPresentationStyle = .formSheet
		recordVC.modalTransitionStyle = .crossDissolve
		splitViewController.present(recordVC, animated: true)
	}
}

extension Coordinator: RecordViewControllerDelegate {
	func finishedRecording(_ recordVC: RecordViewController) {
		recordVC.dismiss(animated: true)
	}
}


extension UIStoryboard {
	func instantiatePlayerNavigationController(with recording: Recording, leftBarButtonItem: UIBarButtonItem) -> UINavigationController {
		let playerNC = instantiateViewController(withIdentifier: "playerNavigationController") as! UINavigationController
		let playerVC = playerNC.viewControllers[0] as! PlayViewController
		playerVC.viewModel.recording.value = recording
		playerVC.navigationItem.leftBarButtonItem = leftBarButtonItem
		playerVC.navigationItem.leftItemsSupplementBackButton = true
		return playerNC
	}
	
	func instantiateRecordViewController(with folder: Folder, delegate: RecordViewControllerDelegate) -> RecordViewController {
		let recordVC = instantiateViewController(withIdentifier: "recorderViewController") as! RecordViewController
		recordVC.viewModel.folder = folder
		recordVC.delegate = delegate
		return recordVC
	}
}
