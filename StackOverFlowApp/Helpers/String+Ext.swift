//
//  String+Ext.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/15/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
