//
//  AvatarImageView.swift
//  AvatarImageView
//
//  Created by Ayush Newatia on 10/08/2016.
//  Copyright © 2016 Spectrum. All rights reserved.
//

import UIKit

public enum Shape {
    case Circle
    case Square
}

public class AvatarImageView: UIImageView {
    
    public var data: AvatarImageViewDataSource? {
        didSet {
            setup()
        }
    }
    public var configuration: AvatarImageViewConfiguration
        = DefaultConfiguration()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.clearColor()
        
        guard let data = data else {
            image = nil
            return
        }
        
        if let avatar = data.avatar {
            image = avatar
            if configuration.shape == .Circle { layer.cornerRadius = bounds.size.width/2 }
        }
        else {
            image = drawImageWith(data: data)
        }
    }
    
    func textAttributes(fromData data: AvatarImageViewDataSource) -> [String : AnyObject] {
        var attributes: [String : AnyObject] = [NSForegroundColorAttributeName : configuration.textColor]
        let fontSize = bounds.size.width * configuration.textSizeFactor
        
        if let fontName = configuration.fontName {
            attributes[NSFontAttributeName] = UIFont(name: fontName, size: fontSize)
        }
        else {
            attributes[NSFontAttributeName] = UIFont.systemFontOfSize(fontSize)
        }
        
        return attributes
    }
    
    func drawImageWith(data data:AvatarImageViewDataSource) -> UIImage {
        let scale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        if configuration.shape == .Circle {
            let circlePath = CGPathCreateWithEllipseInRect(self.bounds, nil)
            CGContextAddPath(context, circlePath)
            CGContextClip(context)
        }
        
        CGContextSetFillColorWithColor(context, data.bgColor == nil ? randomColor() : data.bgColor!.CGColor)
        CGContextFillRect(context, self.bounds)
        
        let initials = data.initials as NSString
        let textAttrs = textAttributes(fromData: data)
        let textRectSize = initials.sizeWithAttributes(textAttrs)
        let textRect = CGRectMake(bounds.size.width / 2 - textRectSize.width / 2,
                              bounds.size.height / 2 - textRectSize.height / 2,
                              textRectSize.width,
                              textRectSize.height)
        
        initials.drawInRect(textRect, withAttributes: textAttrs)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: Utilities
    private func randomColor() -> CGColor {
        srand48(Int(arc4random()))
        
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0).CGColor
    }

}