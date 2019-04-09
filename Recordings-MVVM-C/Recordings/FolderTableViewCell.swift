//
//  FolderTableViewCell.swift
//  Recordings
//
//  Created by elton.lee on 4/9/19.
//

import UIKit

final class FolderTableViewCell: UITableViewCell {
	static let reuseIdentifier: String = String(describing: type(of: self))

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		textLabel?.contentMode = .left
		accessoryType = .disclosureIndicator
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
