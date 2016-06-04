//
//  Izik @ Lisbon
//

import XCTest
@testable import SearchableTextView

class SearchableTextViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
  func test_select_highlight_all_matches_and_mark_the_first_one() {
    let subject = SearchableTextView()
    subject.text = "some text - bla. Again with different casing - BLA, and again  - BlaBLA"
    subject.selectNext("bla", direction: Direction.Down)
    XCTAssertEqual(4, subject.totalMatches)
    
    for match in subject._matches {
      let str = (subject.text as NSString).substringWithRange(match)
      XCTAssertEqual(str.lowercaseString, "bla")
    }
    
    XCTAssertEqual(subject.matchesIterator, 0)
  }
  
  func test_select_iterate_between_matches_direction_down() {
    let subject = SearchableTextView()
    subject.text = "some text - bla. Again with different casing - BLA, and again  - BlaBLA"
    subject.selectNext("bla", direction: Direction.Down)
    XCTAssertEqual(subject.matchesIterator, 0)
    
    subject.selectNext("bla", direction: Direction.Down)
    XCTAssertEqual(subject.matchesIterator, 1)
    
    subject.selectNext("bla", direction: Direction.Down)
    XCTAssertEqual(subject.matchesIterator, 2)
    
    subject.selectNext("bla", direction: Direction.Down)
    XCTAssertEqual(subject.matchesIterator, 3)
    
    subject.selectNext("bla", direction: Direction.Down)
    XCTAssertEqual(subject.matchesIterator, 0)
  }
  
  func test_select_iterate_between_matches_direction_up() {
    let subject = SearchableTextView()
    subject.text = "some text - bla. Again with different casing - BLA, and again  - BlaBLA"
    subject.selectNext("bla", direction: Direction.Up)
    XCTAssertEqual(subject.matchesIterator, 3)
    
    subject.selectNext("bla", direction: Direction.Up)
    XCTAssertEqual(subject.matchesIterator, 2)
    
    subject.selectNext("bla", direction: Direction.Up)
    XCTAssertEqual(subject.matchesIterator, 1)
    
    subject.selectNext("bla", direction: Direction.Up)
    XCTAssertEqual(subject.matchesIterator, 0)
    
    subject.selectNext("bla", direction: Direction.Up)
    XCTAssertEqual(subject.matchesIterator, 3)
  }
}
