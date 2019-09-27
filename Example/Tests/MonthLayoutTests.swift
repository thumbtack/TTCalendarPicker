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

import XCTest
@testable import TTCalendarPicker

private let layoutWidth: CGFloat = 375
private let contentInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
private let spacing: CGFloat = 1
private let fixedCellHeight: CGFloat = 42
private let cellAspectRatio: CGFloat = 0.88
private let calendar = Calendar(identifier: .gregorian)
private let headerHeight: CGFloat = 25
private let month = 10
private let year = 2019

class MonthLayoutTests: XCTestCase {
    var fixedFixed: MonthLayout!
    var fixedAspect: MonthLayout!
    var dynamicFixed: MonthLayout!
    var dynamicAspect: MonthLayout!
    var allLayouts: [MonthLayout]!

    override func setUp() {
        super.setUp()
        fixedFixed = monthLayout(withStyle: CalendarStyle(calendarHeightMode: .fixed,
                                                          cellHeightMode: .fixed(fixedCellHeight),
                                                          contentInsets: contentInsets,
                                                          cellSpacingX: spacing,
                                                          cellSpacingY: spacing,
                                                          headerHeight: headerHeight))
        fixedAspect = monthLayout(withStyle: CalendarStyle(calendarHeightMode: .fixed,
                                                           cellHeightMode: .aspectRatio(cellAspectRatio),
                                                           contentInsets: contentInsets,
                                                           cellSpacingX: spacing,
                                                           cellSpacingY: spacing,
                                                           headerHeight: headerHeight))
        dynamicFixed = monthLayout(withStyle: CalendarStyle(calendarHeightMode: .dynamic,
                                                            cellHeightMode: .fixed(fixedCellHeight),
                                                            contentInsets: contentInsets,
                                                            cellSpacingX: spacing,
                                                            cellSpacingY: spacing,
                                                            headerHeight: headerHeight))
        dynamicAspect = monthLayout(withStyle: CalendarStyle(calendarHeightMode: .dynamic,
                                                             cellHeightMode: .aspectRatio(cellAspectRatio),
                                                             contentInsets: contentInsets,
                                                             cellSpacingX: spacing,
                                                             cellSpacingY: spacing,
                                                             headerHeight: headerHeight))
        allLayouts = [fixedFixed, fixedAspect, dynamicFixed, dynamicAspect]
    }

    override func tearDown() {
        fixedFixed = nil
        fixedAspect = nil
        dynamicFixed = nil
        dynamicAspect = nil
        allLayouts = nil
        super.tearDown()
    }


    func testInitialization() {
        for layout in allLayouts {
            XCTAssertEqual(layout.month, 10)
            XCTAssertEqual(layout.year, 2019)
            XCTAssertEqual(layout.calendar, calendar)
            XCTAssertEqual(layout.layoutWidth, layoutWidth)
        }
    }

    func testNumberOfWeeksAndCells() {
        for layout in [fixedAspect, fixedFixed] {
            XCTAssertEqual(layout!.numberOfWeeks, 6)
            XCTAssertEqual(layout!.numberOfCells, 42)
        }

        for layout in [dynamicAspect, dynamicFixed] {
            XCTAssertEqual(layout!.numberOfWeeks, 5)
            XCTAssertEqual(layout!.numberOfCells, 35)
        }
    }

    func testCellFrames() {
        let items = [0, 4, 13, 22, 27, 32]

        let fixedFrames = items.map({ fixedFixed.frameForCell(at: $0) })
        let aspectFrames = items.map({ fixedAspect.frameForCell(at: $0) })

        XCTAssertEqual(fixedFrames, items.map({ dynamicFixed.frameForCell(at: $0) }))
        XCTAssertEqual(aspectFrames, items.map({ dynamicAspect.frameForCell(at: $0) }))

        for frame in fixedFrames + aspectFrames {
            XCTAssertEqual(frame.width, 48, accuracy: 0)
        }

        for frame in fixedFrames {
            XCTAssertEqual(frame.height, fixedCellHeight)
        }

        for frame in aspectFrames {
            XCTAssertEqual(frame.height, round(frame.width * cellAspectRatio))
        }

        XCTAssertEqual(fixedFrames[0].minX, 17, accuracy: 0)
        XCTAssertEqual(fixedFrames[2].minX, 311, accuracy: 0)
        XCTAssertEqual(fixedFrames[5].minX, 213, accuracy: 0)

        XCTAssertEqual(aspectFrames[0].minX, 17, accuracy: 0)
        XCTAssertEqual(aspectFrames[2].minX, 311, accuracy: 0)
        XCTAssertEqual(aspectFrames[5].minX, 213, accuracy: 0)

        XCTAssertEqual(fixedFrames[0].minY, 38, accuracy: 0)
        XCTAssertEqual(fixedFrames[2].minY, 81, accuracy: 0)
        XCTAssertEqual(fixedFrames[5].minY, 210, accuracy: 0)

        XCTAssertEqual(aspectFrames[0].minY, 38, accuracy: 0)
        XCTAssertEqual(aspectFrames[2].minY, 81, accuracy: 0)
        XCTAssertEqual(aspectFrames[5].minY, 210, accuracy: 0)
    }

    func testFrameForMonthHeader() {
        for layout in allLayouts {
            XCTAssertEqual(layout.frameForMonthHeader(),
                           CGRect(x: contentInsets.left,
                                  y: contentInsets.top,
                                  width: layoutWidth - contentInsets.left - contentInsets.right,
                                  height: headerHeight))
        }
    }

    func testBackgroundFrame() {
        for frame in [fixedFixed.backgroundFrame, fixedAspect.backgroundFrame, dynamicFixed.backgroundFrame, dynamicAspect.backgroundFrame] {
            XCTAssertEqual(frame.minX, 16.0)
            XCTAssertEqual(frame.minY, 37.0)
            XCTAssertEqual(frame.width, 344.0)
        }

        XCTAssertEqual(fixedFixed.backgroundFrame.maxY, 296, accuracy: 0)
        XCTAssertEqual(fixedAspect.backgroundFrame.maxY, 296, accuracy: 0)
        XCTAssertEqual(dynamicFixed.backgroundFrame.maxY, 253, accuracy: 0)
        XCTAssertEqual(dynamicAspect.backgroundFrame.maxY, 253, accuracy: 0)
    }

    func testDateForCell() {
        for layout in allLayouts {
            var date = layout.dateForCell(at: 0)
            XCTAssertEqual(calendar.component(.day, from: date), 29)
            XCTAssertEqual(calendar.component(.month, from: date), 9)
            XCTAssertEqual(calendar.component(.year, from: date), 2019)

            date = layout.dateForCell(at: 14)
            XCTAssertEqual(calendar.component(.day, from: date), 13)
            XCTAssertEqual(calendar.component(.month, from: date), 10)
            XCTAssertEqual(calendar.component(.year, from: date), 2019)

            date = layout.dateForCell(at: 34)
            XCTAssertEqual(calendar.component(.day, from: date), 2)
            XCTAssertEqual(calendar.component(.month, from: date), 11)
            XCTAssertEqual(calendar.component(.year, from: date), 2019)
        }

        for layout in [fixedFixed, dynamicFixed] {
            let date = layout!.dateForCell(at: 39)
            XCTAssertEqual(calendar.component(.day, from: date), 7)
            XCTAssertEqual(calendar.component(.month, from: date), 11)
            XCTAssertEqual(calendar.component(.year, from: date), 2019)
        }
    }

    func testHeightForWidth() {
        for layout in allLayouts {
            XCTAssertEqual(layout.backgroundFrame.maxY + contentInsets.bottom, layout.preferredHeight)
        }
    }

    private func monthLayout(withStyle style: CalendarStyle) -> MonthLayout {
        return MonthLayout(
            month: month,
            year: year,
            calendar: calendar,
            layoutWidth: layoutWidth,
            calendarStyle: style
        )
    }
    
}
