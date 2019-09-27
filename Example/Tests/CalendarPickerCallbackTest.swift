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

import Foundation
import XCTest
@testable import TTCalendarPicker

class CalendrPickerCallBackTest: XCTestCase {
    var calendar: Calendar!
    var today: Date!
    var controller: ExampleViewController!
    var calendarPicker: TestableCalendarPicker!

    private var callbackDelegate: CallbackDelegate!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        today = calendar.date(from: DateComponents(year: 2019, month: 10, day: 19))!
        calendarPicker = TestableCalendarPicker(date: today, calendar: calendar)
        calendarPicker.frame = CGRect(x: 0, y: 0, width: 375, height: 600)
        calendarPicker.today = today
        calendarPicker.calendarHeightMode = .dynamic

        controller = ExampleViewController(calendarPicker: calendarPicker)

        callbackDelegate = CallbackDelegate()
        calendarPicker.delegate = callbackDelegate
        calendarPicker.layoutIfNeeded()
    }

    override func tearDown() {
        calendar = nil
        today = nil
        controller = nil
        callbackDelegate = nil
        super.tearDown()
    }

    func testCalendarScrollCallbacks() {
        var willScrollCalled = false
        var heightWillChangeCalled = false
        var heightDidChangeCalled = false

        callbackDelegate.didScrollToMonthBlock = { month, year in
            willScrollCalled = true
        }
        callbackDelegate.heightWillChangeBlock = {
            heightWillChangeCalled = true
        }
        callbackDelegate.heightDidChangeBlock = {
            XCTAssertTrue(heightWillChangeCalled, "WillChange should be called before didChange")
            heightDidChangeCalled = true
        }
        calendarPicker.scrollTo(month: 5, year: 2020, animated: false)
        calendarPicker.layoutIfNeeded()

        XCTAssertTrue(heightWillChangeCalled)
        XCTAssertTrue(heightDidChangeCalled)
        XCTAssertTrue(willScrollCalled)
    }
}


private class CallbackDelegate: CalendarPickerDelegate {
    var heightWillChangeBlock: (() -> Void)?
    var heightDidChangeBlock: (() -> Void)?
    var didScrollToMonthBlock: ((_: Int, _: Int) -> Void)?

    func calendarPickerHeightWillChange(_ calendarPicker: CalendarPicker) {
        heightWillChangeBlock?()
    }

    func calendarPickerHeightDidChange(_ calendarPicker: CalendarPicker) {
        heightDidChangeBlock?()
    }

    func calendarPicker(_ calendarPicker: CalendarPicker, didScrollToMonth month: Int, year: Int) {
        didScrollToMonthBlock?(month, year)
    }
}
