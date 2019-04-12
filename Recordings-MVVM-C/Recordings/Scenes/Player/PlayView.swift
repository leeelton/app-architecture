//
//  PlayView.swift
//  Recordings
//
//  Created by elton.lee on 4/12/19.
//

import UIKit

final class PlayView: UIView {

	let contentStackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 30.0)
	let noRecordingLabel = UILabel()
	let activeItemElementsStackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 20.0)
	let nameStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 10.0)
	let nameLabel = UILabel()
	let nameTextField = UITextField()
	let progressStackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 10.0)
	let progressLabelStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 0.0)
	let progressLabel = UILabel()
	let durationLabel = UILabel()
	let progressSlider = UISlider()
	let playButton = UIButton()

	private var contentStackViewConstraints: [NSLayoutConstraint] {
		return [
			contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
			contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
			contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = .white

		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentStackView)
		contentStackView.addArrangedSubview(noRecordingLabel)
		contentStackView.addArrangedSubview(activeItemElementsStackView)

		activeItemElementsStackView.addArrangedSubview(nameStackView)
		activeItemElementsStackView.addArrangedSubview(progressStackView)
		activeItemElementsStackView.addArrangedSubview(playButton)

		nameStackView.addArrangedSubview(nameLabel)
		nameStackView.addArrangedSubview(nameTextField)

		progressStackView.addArrangedSubview(progressLabelStackView)
		progressStackView.addArrangedSubview(progressSlider)

		progressLabelStackView.addArrangedSubview(progressLabel)
		progressLabelStackView.addArrangedSubview(durationLabel)

		NSLayoutConstraint.activate(contentStackViewConstraints)

		setupNoRecordingLabel()
		setupNameStackView()
		setupProgressLabels()
		setupProgressSlider()
		setupPlayButton()
	}

	private func setupNoRecordingLabel() {
		noRecordingLabel.font = .preferredFont(forTextStyle: .callout)
	}

	private func setupNameStackView() {
		nameLabel.text = "Name"
		nameLabel.font = .preferredFont(forTextStyle: .body)
		nameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .vertical)
		nameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .horizontal)
		nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
		nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
		nameTextField.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
		nameTextField.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
		nameTextField.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .vertical)
		nameTextField.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
	}

	private func setupProgressLabels() {
		progressLabel.font = .preferredFont(forTextStyle: .body)
		progressLabel.textAlignment = .left
		durationLabel.font = .preferredFont(forTextStyle: .body)
		durationLabel.textAlignment = .right

	}

	private func setupProgressSlider() {
		progressSlider.minimumValue = 0.0
		progressSlider.maximumValue = 1.0
		progressSlider.value = 0.5
		progressSlider.thumbTintColor = .oranji
		progressSlider.tintColor = .black
		progressSlider.isContinuous = true
	}

	private func setupPlayButton() {
		playButton.setTitle("Play", for: .normal)
		playButton.setTitleColor(.white, for: .normal)
		playButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
		playButton.accessibilityIdentifier = "Play Button"
		playButton.backgroundColor = .oranji
		playButton.layer.cornerRadius = 8.0
	}

}

extension UIStackView {
	convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) {
		self.init()
		self.axis = axis
		self.alignment = alignment
		self.distribution = distribution
		self.spacing = spacing
	}
}
