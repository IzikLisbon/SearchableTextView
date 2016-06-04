//
//  Izik @ Lisbon
//

import Foundation
import UIKit

public enum Direction {
  case Up
  case Down
}

public class SearchableTextView : UITextView {
  public var searchString = ""
  public var selectedColor = UIColor.yellowColor()
  public var matchesIterator = -1
  public var searchOptions = NSRegularExpressionOptions.CaseInsensitive
  private var _matches: [NSRange] = []
  private var _markingFont: UIFont? = nil
  
  public var markingFont: UIFont {
    get {
      guard let markingFont = self._markingFont else {
        let boldFont = UIFont(descriptor: self.font!.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold), size: self.font!.pointSize + 5)
        return boldFont
      }
      
      return markingFont
    }
    set {
      self._markingFont = newValue
    }
  }
  
  public var totalMatches: Int {
    return self._matches.count
  }
  
  public func selectNext(str: String, direction: Direction) {
    guard !str.isEmpty else { self.clearSelections(); return; }
    
    if self.searchString != str {
      self.clearSelections()
      
      self.searchString = str
      self._matches = self.findMatches(self.searchString)
      self.highlightAll()
    }
    
    if direction == .Down {
      self.markNext()
    } else {
      self.markPrev()
    }
  }
  
  public func clearSelections() {
    self.searchString = ""
    self.attributedText = NSMutableAttributedString(string: self.text)
    self._matches = []
    self.matchesIterator = -1
  }
  
  // MARK: Private methods
  
  private func markNext() {
    self.matchesIterator = self.nextIterator()
    self.markCurrent()
  }
  
  private func markPrev() {
    self.matchesIterator = self.prevIterator()
    self.markCurrent()
  }
  
  private func prevIterator() -> Int {
    guard self.matchesIterator > 0 else { return self.totalMatches - 1 }
    return self.matchesIterator - 1
  }
  
  private func nextIterator() -> Int {
    guard self.matchesIterator < self.totalMatches - 1 else { return 0 }
    return self.matchesIterator + 1
  }
  
  private func markCurrent() {
    let currentRange = self._matches[self.matchesIterator]
    let prevRange = self._matches[self.prevIterator()]
    let nextRange = self._matches[self.nextIterator()]
    
    let attributed = NSMutableAttributedString(attributedString: self.attributedText)
    
    attributed.removeAttribute(NSFontAttributeName, range: prevRange)
    attributed.removeAttribute(NSFontAttributeName, range: nextRange)
    attributed.addAttribute(NSFontAttributeName, value: self.markingFont, range: currentRange)
    
    self.attributedText = attributed
  }
  
  private func highlightAll() {
    let attributed = NSMutableAttributedString(string: self.text)
    for range in self._matches {
      attributed.addAttribute(NSBackgroundColorAttributeName, value: self.selectedColor, range: range)
    }
    self.attributedText = attributed
  }
  
  private func findMatches(searchString: String) -> [NSRange] {
    guard let regex = try? NSRegularExpression(pattern: searchString, options: self.searchOptions) else { return [] }
    
    var matches: [NSRange] = []
    let range = NSRange(location: 0, length: self.text.utf16.count)
    
    for match in regex.matchesInString(self.text, options: .ReportProgress, range: range) {
      matches.append(match.range)
    }
    
    return matches
  }
  
  
}
