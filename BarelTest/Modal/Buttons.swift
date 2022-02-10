//
//  Buttons.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 26.01.2022.
//

import UIKit


class CornerView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}

class CornerButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
}
