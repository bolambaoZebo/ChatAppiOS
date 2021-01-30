
//  DNATextField.swift
//  dna-app-template
//
//  Created by Shem Chavez on 8/29/19.
//  Copyright © 2019 DNA Micro. All rights reserved.
//

import Foundation
import Material

protocol CustomTextFielddDelegate {
    
    func clear(_ dnaTextField: CustomTextField)
}

class CustomTextField: ErrorTextField {
    
  
    
    open var errorHorizontalOffset: CGFloat = 0 {
      didSet {
        layoutSubviews()
      }
    }
    
    open var isCanPerformAction: Bool = true
    
    open override var isEnabled: Bool {
        didSet {
            isUserInteractionEnabled = isEnabled
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutErrorLabel()
        
    }
    
}

extension CustomTextField {
    
    func layoutErrorLabel() {
        var errorHorizontalOffest = self.errorHorizontalOffset
        if let leftView = leftView {
            errorHorizontalOffest += leftView.frame.width
        }
        errorLabel.frame.origin.x = errorHorizontalOffest
    }
}

extension CustomTextField {
    
    @discardableResult
    func set(delegate: TextFieldDelegate) -> CustomTextField {
        self.delegate = delegate
        return self
    }
    
    
    @discardableResult
    func set(error: String) -> CustomTextField {
        self.error = error
        return self
    }
    
    @discardableResult
    func set(isCanPerformAction: Bool) -> CustomTextField {
        self.isCanPerformAction = isCanPerformAction
        return self
    }
    
    @discardableResult
    func set(isClearIconButtonEnabled: Bool) -> CustomTextField {
        self.isClearIconButtonEnabled = isClearIconButtonEnabled
        return self
    }
    
    @discardableResult
    func set(isSecureEntry: Bool) -> CustomTextField {
        self.isSecureTextEntry = isSecureEntry
        return self
    }
    
    @discardableResult
    func set(keyboardType: UIKeyboardType) -> CustomTextField {
        self.keyboardType = keyboardType
        return self
    }
    
    @discardableResult
    func set(leftViewIcon: UIImage?) -> CustomTextField {
        if #available(iOS 13.0, *) {
            let padding: CGFloat = 4
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: padding * 2 + 20, height: 23))
            let imageView = UIImageView(frame: CGRect(x: padding, y: 0, width: 20, height: 23))
            imageView.image = leftViewIcon
            outerView.addSubview(imageView)
            self.leftView = outerView
        } else {
             self.leftView = UIImageView(image: leftViewIcon)
        }
        return self
    }
    
    @discardableResult
    func set(placeholder: String) -> CustomTextField {
        self.placeholder = placeholder
        return self
    }
        
    @discardableResult
    func set(placeholderColor: UIColor) -> CustomTextField {
        self.placeholderNormalColor = placeholderColor
        self.placeholderActiveColor = placeholderColor
        return self
    }
    
    @discardableResult
    func set(placeholderHorizontalOffset: CGFloat) -> CustomTextField {
        self.placeholderHorizontalOffset = placeholderHorizontalOffset
        return self
    }
    
    @discardableResult
    func set(textAlignment: NSTextAlignment) -> CustomTextField {
        self.textAlignment = textAlignment
        return self
    }
    
    
}


extension CustomTextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return isCanPerformAction
    }
    
    public func applyStyle(error: String,_ cornerRadius: Int? = nil) -> CustomTextField {
        self.error = error
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 5
        self.dividerNormalColor = .clear
        self.dividerActiveColor = .clear
        
        return self
    }
}

