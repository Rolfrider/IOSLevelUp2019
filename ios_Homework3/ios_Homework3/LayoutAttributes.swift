//
//  LayoutAttributes.swift
//  ios_Homework3
//
//  Created by Rafał Kwiatkowski on 30/03/2019.
//  Copyright © 2019 Rafał Kwiatkowski. All rights reserved.
//

import UIKit

class LayoutAttributes: UICollectionViewLayoutAttributes {
    
    var color = UIColor.green
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? LayoutAttributes else {
            return super.copy(with: zone)        }
        
        copiedAttributes.color = color
        
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? LayoutAttributes else {
            return false
        }
        
        if NSValue(nonretainedObject: otherAttributes.color) != NSValue(nonretainedObject: color){
            return false
        }
        
        return super.isEqual(object)
    }
}
