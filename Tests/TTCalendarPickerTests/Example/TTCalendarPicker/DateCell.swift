// Copyright 2019 Thumbtack, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

class DateCell: UICollectionViewCell {
    func setText(_ text: String) {
        label.text = text
    }

    var isInVisibleMonth: Bool = true {
        didSet {
            updateLabelColor()
        }
    }

    private var borderView: UIView?
    private let label = UILabel()

    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
            updateLabelColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false

        layer.zPosition = 0
        label.textAlignment = .center

        contentView.clipsToBounds = false
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        updateBackgroundColor()
        updateLabelColor()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }

    private func updateLabelColor() {
        if isSelected {
            label.textColor = .white
        } else if isInVisibleMonth {
            label.textColor = .black
        } else {
            label.textColor = UIColor(white: 0.8, alpha: 1)
        }
    }

    private func updateBackgroundColor() {
        if isSelected {
            backgroundColor = UIColor(red: 0, green: 0.6235, blue: 0.851, alpha: 1.0)
        } else {
            backgroundColor = .white
        }
    }
}
