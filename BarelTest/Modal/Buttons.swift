//
//  Buttons.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 26.01.2022.
//

import UIKit


class CornerClass: UIControl {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}

class CornerButton: CornerClass {
}
