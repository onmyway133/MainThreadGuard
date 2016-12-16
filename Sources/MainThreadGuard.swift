//
//  MainThreadGuard.swift
//  MainThreadGuard
//
//  Created by Khoa Pham on 30/04/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation
import UIKit

// Reference:
// http://nshipster.com/swift-objc-runtime/
// https://gist.github.com/steipete/5664345

extension UIView {
  open override class func initialize() {
    struct Static {
      static let token = UUID().uuidString
    }

    // make sure this isn't a subclass
    if self !== UIView.self {
      return
    }

    DispatchQueue.mainThreadGuard_once(Static.token) {
      let swizzle: (String, String) -> Void = { (original, swizzled) in
        let originalSelector = Selector(original)
        let swizzledSelector = Selector(swizzled)

        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
          class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
          method_exchangeImplementations(originalMethod, swizzledMethod)
        }
      }

      let pairs: [String: String] = [
        "setNeedsLayout": "guard_setNeedsLayout",
        "setNeedsDisplay": "guard_setNeedsDisplay",
        "setNeedsDisplayInRect:": "guard_setNeedsDisplayInRect:"
      ]

      pairs.forEach { (key, value) in
        swizzle(key, value)
      }
    }
  }

  // MARK: Method Swizzling

  func guard_setNeedsLayout() {
    guard_check()
    guard_setNeedsLayout()
  }

  func guard_setNeedsDisplay() {
    guard_check()
    guard_setNeedsDisplay()
  }

  func guard_setNeedsDisplayInRect(_ rect: CGRect) {
    guard_check()
    guard_setNeedsDisplayInRect(rect)
  }

  // MARK: Checking
  func guard_check() {
    assert(Thread.isMainThread)

    // iOS 8 layouts the MFMailComposeController in a background thread on an UIKit queue.
  }
}

private extension DispatchQueue {

  static var mainThreadGuardTokens = [String]()

  class func mainThreadGuard_once(_ token: String, closure: () -> Void) {
    objc_sync_enter(self)

    defer {
      objc_sync_exit(self)
    }

    guard !mainThreadGuardTokens.contains(token) else {
      return
    }

    mainThreadGuardTokens.append(token)
    closure()
  }
}
