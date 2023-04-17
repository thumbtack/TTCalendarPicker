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
import iOSSnapshotTestCase

// Images generated with XCode 11, iPhone 8 (12.2)
class CalendarPickerSnapshotTest: FBSnapshotTestCase {
    var calendar: Calendar!
    var today: Date!
    var controller: ExampleViewController!
    var calendarPicker: TestableCalendarPicker!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        today = calendar.date(from: DateComponents(year: 2019, month: 10, day: 19))!
        calendarPicker = TestableCalendarPicker(date: today, calendar: calendar)
        calendarPicker.frame = CGRect(x: 0, y: 0, width: 375, height: 600)
        calendarPicker.today = today

        controller = ExampleViewController(calendarPicker: calendarPicker)
        calendarPicker.layoutIfNeeded()
    }

    override func tearDown() {
        calendar = nil
        today = nil
        controller = nil
        super.tearDown()
    }

    func testDefaultConfiguration() {
        verify()
    }

    func testFixedHeight() {
        calendarPicker.calendarHeightMode = .fixed
        // A bit of a cheat, since the snapshot is taken before the collectionview fills in the additional cells
        calendarPicker.reloadData()
        verify()
    }

    func testFixedHeightCells() {
        calendarPicker.cellHeightMode = .fixed(60)
        verify()
    }

    func testDifferentAspectRatios() {
        calendarPicker.gridColor = .darkGray

        calendarPicker.cellHeightMode = .aspectRatio(0.2)
        verify(identifier: "short")

        calendarPicker.cellHeightMode = .aspectRatio(1)
        verify(identifier: "square")

        calendarPicker.cellHeightMode = .aspectRatio(1.3)
        verify(identifier: "tall")
    }

    func testDifferentInsets() {
        calendarPicker.gridInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        verify(identifier: "top and bottom")

        calendarPicker.gridInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        verify(identifier: "left and right")
    }

    func testDifferentSpacing() {
        calendarPicker.gridColor = .darkGray

        calendarPicker.cellSpacingX = 0
        calendarPicker.cellSpacingY = 0
        verify(identifier: "touching")

        calendarPicker.cellSpacingX = 5
        calendarPicker.cellSpacingY = 5
        verify(identifier: "distant")

        calendarPicker.cellSpacingX = 0
        calendarPicker.cellSpacingY = 5
        verify(identifier: "rows")

        calendarPicker.cellSpacingX = 5
        calendarPicker.cellSpacingY = 0
        verify(identifier: "columns")
    }

    func testMonthHeaderHeight() {
        calendarPicker.monthHeaderHeight = 0
        verify(identifier: "none")

        calendarPicker.monthHeaderHeight = 100
        verify(identifier: "too much")
    }

    func testSelectedDates() {
        let date = calendar.date(from: DateComponents(year: 2019, month: 10, day: 5))!
        calendarPicker.selectedDates = [date]
        verify(identifier: "one")

        let date2 = calendar.date(from: DateComponents(year: 2019, month: 10, day: 19))!
        let date3 = calendar.date(from: DateComponents(year: 2019, month: 10, day: 22))!
        calendarPicker.allowsMultipleSelection = true
        calendarPicker.selectedDates = [date, date2, date3]
        verify(identifier: "many")

        calendarPicker.deselectAll()
        verify(identifier: "deselected")
    }

    func testGridColor() {
        calendarPicker.gridColor = .purple
        verify(identifier: "purple")
    }

    func testNavigation() {
        calendarPicker.scrollToNext(animated: false)
        verify(identifier: "scrollToNext")

        calendarPicker.scrollTo(month: 7, year: 2020, animated: false)
        verify(identifier: "July 2020")

        calendarPicker.scrollToToday(animated: false)
        verify(identifier: "today")

        calendarPicker.scrollToPrev(animated: false)
        verify(identifier: "previous")
    }

    private func verify(identifier: String = "") {
        guard let view = controller.view else {
            XCTFail("Unable to get view from view controller")
            return
        }
        
        view.layoutIfNeeded()
        FBSnapshotVerifyView(view, identifier: identifier)
    }
}
