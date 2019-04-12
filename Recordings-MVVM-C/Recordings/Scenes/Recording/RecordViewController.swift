import UIKit
import AVFoundation
import RxSwift
import RxCocoa

protocol RecordViewControllerDelegate: class {
	func finishedRecording(_ recordVC: RecordViewController)
}

final class RecordViewController: UIViewController, AVAudioRecorderDelegate {
	let viewModel = RecordViewModel()
	let disposeBag = DisposeBag()

	var recordView: RecordingView!

	weak var delegate: RecordViewControllerDelegate!
	var audioRecorder: Recorder?

	override func loadView() {
		let newView = RecordingView(frame: UIScreen.main.bounds)
		view = newView
		recordView = newView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupBindings()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		audioRecorder = viewModel.folder?.store?.fileURL(for: viewModel.recording).flatMap { url in
			Recorder(url: url) { [unowned self] time in
				self.viewModel.recorderStateChanged(time: time)
			}
		}
		if audioRecorder == nil {
			delegate.finishedRecording(self)
		}
	}

	private func setupBindings() {
		viewModel.timeLabelText
			.bind(to: recordView.timeLabel.rx.text)
			.disposed(by: disposeBag)

		recordView.stopButton
			.rx
			.tap
			.subscribe(onNext: { [unowned self] _ in
				self.audioRecorder?.stop()
				self.modalTextAlert(title: .saveRecording, accept: .save, placeholder: .nameForRecording) { string in
					self.viewModel.recordingStopped(title: string)
					self.delegate.finishedRecording(self)
				}
			})
			.disposed(by: disposeBag)
	}
}

fileprivate extension String {
	static let saveRecording = NSLocalizedString("Save recording", comment: "Heading for audio recording save dialog")
	static let save = NSLocalizedString("Save", comment: "Confirm button text for audio recoding save dialog")
	static let nameForRecording = NSLocalizedString("Name for recording", comment: "Placeholder for audio recording name text field")
}
