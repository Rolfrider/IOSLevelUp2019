//
//  MoonView.swift
//  ios_Homework2
//
//  Created by Rafał Kwiatkowski on 21/03/2019.
//  Copyright © 2019 Rafał Kwiatkowski. All rights reserved.
//
import UIKit

class MoonView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9818069339, green: 1, blue: 0.7711547017, alpha: 1)
        self.layer.cornerRadius = frame.width * 0.5
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
