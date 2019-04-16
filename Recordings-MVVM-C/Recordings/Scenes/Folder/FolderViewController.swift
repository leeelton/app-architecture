import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol FolderViewControllerDelegate: class {
	func didSelect(_ item: Item)
	func createRecording(in folder: Folder)
}

final class FolderViewController: UITableViewController {

	let addFolderBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
	let addRecordingBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

	weak var delegate: FolderViewControllerDelegate? = nil
	
	var viewModel = FolderViewModel()
	private let disposeBag = DisposeBag()

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupTableView()
		setupBindings()
	}
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Item>> {
		return RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, Item>>(
			configureCell: { (dataSource, table, idxPath, item) in
				let identifier = item is Recording ? RecordingTableViewCell.reuseIdentifier : FolderTableViewCell.reuseIdentifier
				let cell = table.dequeueReusableCell(withIdentifier: identifier, for: idxPath)
				cell.textLabel!.text = FolderViewModel.text(for: item)
				return cell
			},
			canEditRowAtIndexPath: { _, _ in
				return true
			}
		)
	}

	// MARK: Setup

	private func setupTableView() {
		tableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: RecordingTableViewCell.reuseIdentifier)
		tableView.register(FolderTableViewCell.self, forCellReuseIdentifier: FolderTableViewCell.reuseIdentifier)
		tableView.dataSource = nil
	}

	private func setupNavigationBar() {
		navigationItem.rightBarButtonItems = [addFolderBarButtonItem, addRecordingBarButtonItem]
	}

	private func setupBindings() {
		viewModel
			.navigationTitleObservable
			.bind(to: rx.title)
			.disposed(by: disposeBag)

		viewModel
			.folderContentsObservable
			.bind(to: tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)

		tableView
			.rx
			.modelDeleted(Item.self)
			.bind(to: viewModel.deleteObserver)
			.disposed(by: disposeBag)

		tableView
			.rx
			.modelSelected(Item.self)
			.bind(to: viewModel.didSelectItemObserver)
			.disposed(by: disposeBag)

		addFolderBarButtonItem
			.rx
			.tap
			.bind(to: rx.modalTextAlert)
			.disposed(by: disposeBag)

		addRecordingBarButtonItem
			.rx
			.tap
			.bind(to: viewModel.createRecordingObserver)
			.disposed(by: disposeBag)

		addRecordingBarButtonItem
			.rx
			.tap
			.subscribe(onNext: { [unowned self] (_) in
				self.delegate?.createRecording(in: self.viewModel.folder.value)
			})
			.disposed(by: disposeBag)
	}
	
	// MARK: UIStateRestoring

	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		coder.encode(viewModel.folder.value.uuidPath, forKey: .uuidPathKey)
	}

	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		if let uuidPath = coder.decodeObject(forKey: .uuidPathKey) as? [UUID], let folder = Store.shared.item(atUUIDPath: uuidPath) as? Folder {
			self.viewModel.folder.value = folder
		} else {
			if var controllers = navigationController?.viewControllers, let index = controllers.firstIndex(where: { $0 === self }) {
				controllers.remove(at: index)
				navigationController?.viewControllers = controllers
			}
		}
	}
}

private extension Reactive where Base: FolderViewController {
	var modalTextAlert: Binder<Void> {
		return Binder<Void>(self.base, binding: { (folderViewController, _) in
			folderViewController.modalTextAlert(title: .createFolder, accept: .create, placeholder: .folderName) { string in
				folderViewController.viewModel.create(folderNamed: string)
				folderViewController.dismiss(animated: true)
			}
		})
	}
}


fileprivate extension String {
	static let uuidPathKey = "uuidPath"

	static let createFolder = NSLocalizedString("Create Folder", comment: "Header for folder creation dialog")
	static let folderName = NSLocalizedString("Folder Name", comment: "Placeholder for text field where folder name should be entered.")
	static let create = NSLocalizedString("Create", comment: "Confirm button for folder creation dialog")
}

