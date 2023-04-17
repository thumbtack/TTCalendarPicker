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
class MonthHeaderView: UICollectionReusableView {
    let monthLabel: UILabel
    let stackView: UIStackView

    var dayOfWeekHeaders: [String] = [] {
        didSet {
            stackView.subviews.forEach({
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            })

            dayOfWeekHeaders.forEach({
                let label = UILabel()
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.text = $0
                label.textAlignment = .center
                stackView.addArrangedSubview(label)
            })
        }
    }

    override init(frame: CGRect) {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually

        monthLabel = UILabel()
        monthLabel.font = UIFont.boldSystemFont(ofSize: 24)
        monthLabel.textAlignment = .center

        super.init(frame: frame)

        addSubview(stackView)
        addSubview(monthLabel)

        monthLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
