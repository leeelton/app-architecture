//
//  RecordView.swift
//  Recordings
//
//  Created by elton.lee on 4/11/19.
//

import UIKit

final class RecordingView: UIView {

	let recordingLabel = UILabel()
	let timeLabel = UILabel()
	let stopButton = UIButton()
	private var contentView: UIView!
	private let stackView = UIStackView()
	private var contentViewConstraints: [NSLayoutConstraint] {
		return [
			contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
			contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			contentView.topAnchor.constraint(equalTo: topAnchor),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
		]
	}
	private var stackViewConstraints: [NSLayoutConstraint] {
		return [
				stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
				stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
				stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
				stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
			]
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		let contentView = UIView(frame: frame)
		self.contentView = contentView
		contentView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.addSubview(stackView)
		stackView.addArrangedSubview(recordingLabel)
		stackView.addArrangedSubview(timeLabel)
		stackView.addArrangedSubview(stopButton)

		NSLayoutConstraint.activate(contentViewConstraints)
		NSLayoutConstraint.activate(stackViewConstraints)

		setupContentView()
		setupStackView()
		setupRecordingLabel()
		setupTimeLabel()
		setupStopButton()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupContentView() {
		contentView.backgroundColor = .white
		contentView.accessibilityIdentifier = "Recording View Content View"
	}

	private func setupStackView() {
		stackView.alignment = .fill
		stackView.distribution = .fill
		stackView.spacing = 10.0
		stackView.axis = .vertical
		stackView.autoresizesSubviews = true
		stackView.accessibilityIdentifier = "Recording View Stack View"
	}

	private func setupRecordingLabel() {
		recordingLabel.font = .preferredFont(forTextStyle: .body)
		recordingLabel.text = "Recording"
		recordingLabel.accessibilityIdentifier = "Recording Label"
		recordingLabel.textAlignment = .center
	}

	private func setupTimeLabel() {
		timeLabel.font = .preferredFont(forTextStyle: .title1)
		timeLabel.accessibilityIdentifier = "Time Label"
		timeLabel.textAlignment = .center
	}

	private func setupStopButton() {
		stopButton.setTitle("Stop", for: .normal)
		stopButton.setTitleColor(.white, for: .normal)
		stopButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
		stopButton.accessibilityIdentifier = "Stop Button"
		stopButton.backgroundColor = .oranji
		stopButton.layer.cornerRadius = 8.0
	}
}
