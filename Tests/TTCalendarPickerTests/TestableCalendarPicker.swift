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
@testable import TTCalendarPicker

class TestableCalendarPicker: CalendarPicker {
    private var _today: Date = Date()
    override var today: Date {
        get { return _today }
        set { _today = newValue }
    }

    public convenience init(date: Date, calendar: Calendar = Calendar.current) {
        let components = calendar.dateComponents([.month, .year], from: date)
        self.init(month: components.month!, year: components.year!, calendar: calendar)
    }
}
