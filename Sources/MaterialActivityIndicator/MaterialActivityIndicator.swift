//
//  MaterialActivityIndicator.swift
//  MaterialActivityIndicator
//
//  Created by Jans Pavlovs on 02/13/2018.
//  Copyright (c) 2018 Jans Pavlovs. All rights reserved.
//

import UIKit

@IBDesignable
public class MaterialActivityIndicatorView: UIView {
    @IBInspectable
    public var color: UIColor = .gray {
        didSet {
            updateIndicatorStrokeColor()
        }
    }

    @IBInspectable
    public var lineWidth: CGFloat = 2.0 {
        didSet {
            indicator.lineWidth = lineWidth
            setNeedsLayout()
        }
    }

    private let indicator = CAShapeLayer()
    private let animator = MaterialActivityIndicatorAnimator()

    private var isAnimating = false

    convenience init() {
        self.init(frame: .zero)
        self.setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        indicator.strokeColor = color.cgColor
        indicator.fillColor = nil
        indicator.lineWidth = lineWidth
        indicator.strokeStart = 0.0
        indicator.strokeEnd = 0.0
        layer.addSublayer(indicator)
        isHidden = true
        backgroundColor = .clear
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ///used to update layer color when environment did change
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateIndicatorStrokeColor()
            }
        }
    }
    
    private func updateIndicatorStrokeColor() {
        indicator.strokeColor = color.cgColor
    }
}

extension MaterialActivityIndicatorView {
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 24, height: 24)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        indicator.frame = bounds

        let diameter = bounds.size.min - indicator.lineWidth
        let path = UIBezierPath(center: bounds.center, radius: diameter / 2)
        indicator.path = path.cgPath
    }
}

extension MaterialActivityIndicatorView {
    public func startAnimating() {
        guard !isAnimating else { return }
        isHidden = false
        animator.addAnimation(to: indicator)
        isAnimating = true
    }

    public func stopAnimating() {
        guard isAnimating else { return }
        isHidden = true
        animator.removeAnimation(from: indicator)
        isAnimating = false
    }
}
