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
import SnapKit
import TTCalendarPicker

class ExampleViewController: UIViewController {
    lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    lazy var dayOfWeekHeaders: [String] = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        return dateFormatter.weekdaySymbols.map({ String($0.prefix(2)) })
    }()

    var calendar: Calendar {
        return calendarPicker.calendar
    }

    var calendarPicker: CalendarPicker

    init(calendarPicker: CalendarPicker? = nil) {
        if let calendarPicker = calendarPicker {
            self.calendarPicker = calendarPicker
        } else {
            let calendar = Calendar(identifier: .gregorian)
            let date = Date()
            self.calendarPicker = CalendarPicker(date: date, calendar: calendar)
        }

        super.init(nibName: nil, bundle: nil)

        self.calendarPicker.registerDateCell(DateCell.self, withReuseIdentifier: "DateCell")
        self.calendarPicker.registerMonthHeaderView(MonthHeaderView.self, withReuseIdentifier: "MonthHeader")
        self.calendarPicker.monthHeaderHeight = 64
        self.calendarPicker.calendarHeightMode = .dynamic
        self.calendarPicker.dataSource = self
        self.calendarPicker.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        let prevButton = UIButton(type: .custom)
        prevButton.setTitle("< Prev", for: .normal)
        prevButton.titleLabel?.textAlignment = .left
        prevButton.addTarget(self, action: #selector(scrollToPrev), for: .touchUpInside)

        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("Next >", for: .normal)
        nextButton.titleLabel?.textAlignment = .right
        nextButton.addTarget(self, action: #selector(scrollToNext), for: .touchUpInside)

        let todayButton = UIButton(type: .custom)
        todayButton.setTitle("Today", for: .normal)
        todayButton.titleLabel?.textAlignment = .center
        todayButton.addTarget(self, action: #selector(scrollToToday), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [prevButton, todayButton, nextButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8
        buttonStack.distribution = .equalSpacing

        view.addSubview(calendarPicker)
        view.addSubview(buttonStack)

        calendarPicker.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.left.right.equalToSuperview()
        }

        buttonStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(calendarPicker.snp.bottom).offset(8)
        }
    }

    @objc
    func scrollToNext() {
        calendarPicker.scrollToNext(animated: true)
    }

    @objc
    func scrollToPrev() {
        calendarPicker.scrollToPrev(animated: true)
    }

    @objc
    func scrollToToday() {
        calendarPicker.scrollToToday(animated: true)
    }
}

extension ExampleViewController: CalendarPickerDataSource {
    func calendarPicker(_ calendarPicker: CalendarPicker, cellForDay day: Int,
                        month: Int, year: Int, inVisibleMonth: Bool, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendarPicker.dequeReusableDateCell(
            withReuseIdentifier: "DateCell",
            indexPath: indexPath)
            as! DateCell
        cell.setText("\(day)")
        cell.isInVisibleMonth = inVisibleMonth
        return cell
    }
}

extension ExampleViewController: CalendarPickerDelegate {
    func calendarPicker(_ calendarPicker: CalendarPicker, headerForMonth month: Int, year: Int, indexPath: IndexPath) -> UICollectionReusableView {
        let header = calendarPicker.dequeMonthHeaderView(withReuseIdentifier: "MonthHeader", indexPath: indexPath) as! MonthHeaderView
        let date = DateComponents(calendar: calendarPicker.calendar, year: year, month: month).date!
        header.monthLabel.text = monthFormatter.string(from: date)
        header.dayOfWeekHeaders = dayOfWeekHeaders
        return header
    }

    func calendarPickerHeightWillChange(_ calendarPicker: CalendarPicker) {
        view.layoutIfNeeded()
    }

    func calendarPickerHeightDidChange(_ calendarPicker: CalendarPicker) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
