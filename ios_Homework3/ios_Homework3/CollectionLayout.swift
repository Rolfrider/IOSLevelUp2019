//
//  CollectionLayout.swift
//  ios_Homework3
//
//  Created by Rafał Kwiatkowski on 29/03/2019.
//  Copyright © 2019 Rafał Kwiatkowski. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {
    
    let size: CGFloat = 200
    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3
    var customLayoutAtrtibutes = [LayoutAttributes]()

    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.itemSize = CGSize(width: size, height: size)
        self.minimumLineSpacing = 50
        
    }
    
    override class var layoutAttributesClass: AnyClass {
        return LayoutAttributes.self
    }
    
    override func prepare() {
        let verticlaInsets = collectionView!.bounds.height/3
        self.sectionInset = UIEdgeInsets(top: verticlaInsets, left: 0, bottom: verticlaInsets, right: 0)
        let numberOfItems = collectionView!.numberOfItems(inSection: 0)
        customLayoutAtrtibutes = [LayoutAttributes]()
        let yPos = (collectionView!.frame.height - itemSize.height)/2
        let startCollectionOffset = (collectionView!.frame.width - itemSize.width)/2
        for i in 0..<numberOfItems {
            let indexPath = IndexPath(item: i, section: 0)
            let pos = CGPoint(x: (itemSize.width + minimumLineSpacing) * CGFloat(i) + startCollectionOffset, y: yPos)
            let frame = CGRect(origin: pos, size: itemSize)
            let attributes = LayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            customLayoutAtrtibutes.append(attributes)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            let leftmostEdge = customLayoutAtrtibutes.map { $0.frame.minX }.min() ?? 0
            let rightmostEdge = customLayoutAtrtibutes.map { $0.frame.maxX }.max() ?? 0
            return CGSize(width: rightmostEdge - leftmostEdge + collectionView!.frame.width - itemSize.width, height: itemSize.height)
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let allAttributesInRect =
            customLayoutAtrtibutes.filter { $0.frame.intersects(rect) }
        
        let visableRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.frame.size)
        
        for attributes in allAttributesInRect where attributes.frame.intersects(visableRect) {
            let distance = visableRect.midX - attributes.center.x
            let normalizedDistance = distance/activeDistance
            if abs(distance) < activeDistance {
                let zoom = 1 + zoomFactor*(1 - abs(normalizedDistance))
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom)
                
                let redV = 2*(1 - abs(normalizedDistance))
                let greenV = 2*abs(normalizedDistance)
                attributes.color = UIColor(red: redV,
                                               green: greenV, blue: 0, alpha: 1)
        
            }
            
        }
        
        return allAttributesInRect
    }
    
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
}


