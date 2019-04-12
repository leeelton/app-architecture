import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISlider {
	public var maximumValue: Binder<Float> {
		return Binder(self.base, binding: { slider, value in
			slider.maximumValue = value
		})
	}
}

final class PlayViewController: UIViewController {

	var playView: PlayView!
	let viewModel = PlayViewModel()
	let disposeBag = DisposeBag()

	override func loadView() {
		let playView = PlayView(frame: UIScreen.main.bounds)
		view = playView
		self.playView = playView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		playView.nameTextField.delegate = self
		setupBindings()
	}

	private func setupBindings() {
		viewModel.navigationTitle
			.bind(to: rx.title)
			.disposed(by: disposeBag)

		viewModel.noRecording
			.bind(to: playView.activeItemElementsStackView.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.hasRecording
			.bind(to: playView.noRecordingLabel.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.timeLabelText
			.bind(to: playView.progressLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.durationLabelText
			.bind(to: playView.durationLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.sliderDuration
			.bind(to: playView.progressSlider.rx.maximumValue)
			.disposed(by: disposeBag)

		viewModel.sliderProgress
			.bind(to: playView.progressSlider.rx.value)
			.disposed(by: disposeBag)

		viewModel.playButtonTitle
			.bind(to: playView.playButton.rx.title(for: .normal))
			.disposed(by: disposeBag)

		viewModel.nameText
			.bind(to: playView.nameTextField.rx.text)
			.disposed(by: disposeBag)

		playView.progressSlider
			.rx
			.controlEvent([.valueChanged])
			.subscribe(onNext: { [unowned self] (_) in
				let s = self.playView.progressSlider
				self.viewModel.setProgress.onNext(TimeInterval(s.value))
			})
			.disposed(by: disposeBag)

		playView.playButton
			.rx
			.tap
			.bind(to: viewModel.togglePlay)
			.disposed(by: disposeBag)
	}
	
	// MARK: UIStateRestoring
	
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		coder.encode(viewModel.recording.value?.uuidPath, forKey: .uuidPathKey)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		if let uuidPath = coder.decodeObject(forKey: .uuidPathKey) as? [UUID], let recording = Store.shared.item(atUUIDPath: uuidPath) as? Recording {
			self.viewModel.recording.value = recording
		}
	}
}

extension PlayViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField) {
		viewModel.nameChanged(textField.text)
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

fileprivate extension String {
	static let uuidPathKey = "uuidPath"
}
