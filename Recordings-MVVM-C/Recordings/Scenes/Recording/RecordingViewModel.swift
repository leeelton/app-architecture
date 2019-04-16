import RxSwift
import RxCocoa
import RxFlow

final class RecordingViewModel: Stepper {
	private let disposeBag = DisposeBag()

	// MARK: Inputs

	var folder: Folder? = nil
	let recording = Recording(name: "", uuid: UUID())

	lazy var saveRecordingWithTitleObserver: AnyObserver<String?> = {
		_saveRecordingWithTitlePublishSubject.asObserver()
	}()

	lazy var updateTime: AnyObserver<TimeInterval> = {
		_duration.asObserver()
	}()

	// MARK: Outputs

	var timeLabelText: Observable<String?> {
		return _duration.asObservable().map(timeString)
	}

	private let _saveRecordingWithTitlePublishSubject = PublishSubject<String?>()
	private let _recordingFinishedPublishSubject = PublishSubject<Void>()
	private let _duration = BehaviorSubject<TimeInterval>(value: 0)

	// Flow

	let steps = PublishRelay<Step>()

	init() {
		setupBindings()
		setupFlowBindings()
	}

	private func setupBindings() {
		_saveRecordingWithTitlePublishSubject
			.subscribe(onNext: { [unowned self] (title) in
				self.saveRecording(title: title)
				self._recordingFinishedPublishSubject.onNext(())
			})
			.disposed(by: disposeBag)
	}

	private func setupFlowBindings() {
		_recordingFinishedPublishSubject
			.map { FolderStep.recordingFinished }
			.bind(to: steps)
			.disposed(by: disposeBag)
	}

	private func saveRecording(title: String?) {
		guard let title = title else {
			recording.deleted()
			return
		}
		recording.setName(title)
		folder?.add(recording)
	}
}
