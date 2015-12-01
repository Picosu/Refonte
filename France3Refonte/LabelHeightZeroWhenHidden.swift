//
//  LabelHeightZeroWhenHidden.swift
//  France3Refonte
//
//  Created by Maxence DE CUSSAC on 04/11/2015.
//  Copyright © 2015 Maxence DE CUSSAC. All rights reserved.
//

import Foundation
import UIKit

/// UILabel qui prend une size zero quand il est caché.
class LabelHeightZeroWhenHidden: UILabel {
    
    override func intrinsicContentSize() -> CGSize {
        if hidden {
            return CGSizeZero
        }
        else {
            super.intrinsicContentSize()
            return CGSizeMake(self.frame.size.width, 50)
        }
    }
    
    override var hidden: Bool {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}