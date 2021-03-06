import RxSwift
import RxDataSources
import RxCocoa
import RxFlow

final class FolderViewModel: Stepper {
	private let disposeBag = DisposeBag()

	// MARK: - Inputs

	lazy var deleteObserver: AnyObserver<Item> = { _deletePublishSubject.asObserver() }()
	lazy var createFolderObserver: AnyObserver<String?> = { _createFolderPublishSubject.asObserver() }()
	lazy var createRecordingObserver: AnyObserver<Void> = { _createRecordingPublishSubject.asObserver() }()
	lazy var didSelectItemObserver : AnyObserver<Item> = { _didSelectItemPublishSubject.asObserver() }()

	// MARK: - Outputs

	// TODO: Remove this Variable
	let folder: Variable<Folder>

	lazy var folderObservable: Observable<Folder?> = {
		return _folderBehaviorSubject
			.flatMapLatest { currentFolder in
				Observable.just(currentFolder)
					.concat(currentFolder.changeObservable.map { _ in currentFolder })
					.takeUntil(currentFolder.deletedObservable)
					.concat(Observable.just(nil))
			}.share(replay: 1)
	}()

	var navigationTitleObservable: Observable<String> {
		return folderObservable.map { folder in
			guard let f = folder else { return "" }
			return f.parent == nil ? .recordings : f.name
		}
	}

	var folderContentsObservable: Observable<[AnimatableSectionModel<Int, Item>]> {
		return folderObservable.map { folder in
			guard let f = folder else { return [AnimatableSectionModel(model: 0, items: [])] }
			return [AnimatableSectionModel(model: 0, items: f.contents)]
		}
	}

	static func text(for item: Item) -> String {
		return "\((item is Recording) ? "🔊" : "📁")  \(item.name)"
	}

	let steps = PublishRelay<Step>()

	private let _deletePublishSubject = PublishSubject<Item>()
	private let _createFolderPublishSubject = PublishSubject<String?>()
	private let _createRecordingPublishSubject = PublishSubject<Void>()
	private let _folderBehaviorSubject: BehaviorSubject<Folder>
	private let _didSelectItemPublishSubject = PublishSubject<Item>()

	init(initialFolder: Folder = Store.shared.rootFolder) {
		_folderBehaviorSubject = BehaviorSubject(value: initialFolder)
		folder = Variable(initialFolder)
		setupBindings()
		setupFlowBindings()
	}

	private func setupBindings() {
		_deletePublishSubject
			.withLatestFrom(_folderBehaviorSubject) { ($0, $1) }
			.subscribe(onNext: { (item, folder) in
				folder.remove(item)
			})
			.disposed(by: disposeBag)

		_createFolderPublishSubject
			.withLatestFrom(_folderBehaviorSubject) { ($0, $1) }
			.subscribe(onNext: { (name, folder) in
				guard let name = name else { return }
				let newFolder = Folder(name: name, uuid: UUID())
				folder.add(newFolder)
			})
			.disposed(by: disposeBag)
	}

	private func setupFlowBindings() {
		_didSelectItemPublishSubject
			.filter { $0 is Folder }
			.map { $0 as! Folder }
			.map { FolderStep.folder(initialFolder: $0) }
			.bind(to: steps)
			.disposed(by: disposeBag)

		_didSelectItemPublishSubject
			.filter { $0 is Recording }
			.map { $0 as! Recording }
			.map { FolderStep.recording($0) }
			.bind(to: steps)
			.disposed(by: disposeBag)

		_createRecordingPublishSubject
			.withLatestFrom(folderObservable)
			.filter { $0 != nil }
			.map { FolderStep.makeRecording(folder: $0!) }
			.bind(to: steps)
			.disposed(by: disposeBag)
	}
}

fileprivate extension String {
	static let recordings = NSLocalizedString("Recordings", comment: "Heading for the list of recorded audio items and folders.")
}
