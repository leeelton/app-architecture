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

final class PlayerViewController: UIViewController {

	var playerView: PlayerView!
	let viewModel = PlayerViewModel()
	let disposeBag = DisposeBag()

	override func loadView() {
		let playView = PlayerView(frame: UIScreen.main.bounds)
		view = playView
		self.playerView = playView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		playerView.nameTextField.delegate = self
		setupBindings()
	}

	private func setupBindings() {
		viewModel.navigationTitle
			.bind(to: rx.title)
			.disposed(by: disposeBag)

		viewModel.noRecording
			.bind(to: playerView.activeItemElementsStackView.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.hasRecording
			.bind(to: playerView.noRecordingLabel.rx.isHidden)
			.disposed(by: disposeBag)

		viewModel.timeLabelText
			.bind(to: playerView.progressLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.durationLabelText
			.bind(to: playerView.durationLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.sliderDuration
			.bind(to: playerView.progressSlider.rx.maximumValue)
			.disposed(by: disposeBag)

		viewModel.sliderProgress
			.bind(to: playerView.progressSlider.rx.value)
			.disposed(by: disposeBag)

		viewModel.playButtonTitle
			.bind(to: playerView.playButton.rx.title(for: .normal))
			.disposed(by: disposeBag)

		viewModel.nameText
			.bind(to: playerView.nameTextField.rx.text)
			.disposed(by: disposeBag)

		playerView.progressSlider
			.rx
			.controlEvent([.valueChanged])
			.subscribe(onNext: { [unowned self] (_) in
				let s = self.playerView.progressSlider
				self.viewModel.setProgress.onNext(TimeInterval(s.value))
			})
			.disposed(by: disposeBag)

		playerView.playButton
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

extension PlayerViewController: UITextFieldDelegate {
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
