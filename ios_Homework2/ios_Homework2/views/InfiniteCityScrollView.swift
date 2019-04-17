//
//  InfiniteScrollView.swift
//  ios_Homework2
//
//  Created by Rafał Kwiatkowski on 20/03/2019.
//  Copyright © 2019 Rafał Kwiatkowski. All rights reserved.
//
import UIKit

class InfiniteCityScrollView: UIScrollView {
    
    private let buildingContainer = BuildingContainer()
    
    private var visibleBuildings: [BuildingView] = []
    
    
    init() {
        super.init(frame: .zero)
        addSubview(buildingContainer)
        showsVerticalScrollIndicator = false
        bounces = false
    }
    
    override var frame: CGRect {
        didSet {
            setup(size: bounds.size)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    func setup(size: CGSize) {
        contentSize = CGSize(width: size.width*3, height: BuildingView.maxBuildingHeight)
        buildingContainer.frame = CGRect(origin: .zero, size: contentSize)
        backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        indicatorStyle = .white
        visibleBuildings.forEach { $0.removeFromSuperview() }
        visibleBuildings.removeAll()
        contentOffset.x = (contentSize.width - bounds.width) / 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recenter()
        let visibleBounds = convert(bounds, to: buildingContainer)
        tileBuildings(from: visibleBounds.minX, to: visibleBounds.maxX)
        
    }
    
    func tileBuildings(from minX: CGFloat, to maxX: CGFloat) {
        if visibleBuildings.count == 0 { _  = placeNewBuildingOnRight(edge: 0.0)}
        
        
        var lastvisibleBuilding = visibleBuildings.last!
        while lastvisibleBuilding.frame.maxX < maxX {
            lastvisibleBuilding = placeNewBuildingOnRight( edge: lastvisibleBuilding.frame.maxX)
        }
        
        var firstVisibleBuilding = visibleBuildings.first!
        while firstVisibleBuilding.frame.minX > minX {
            firstVisibleBuilding = placeNewBuildingOnLeft( edge: firstVisibleBuilding.frame.minX)
        }
        
        var indicesToRemove: [Int] = []
        for (index, building) in visibleBuildings.enumerated() {
            if building.frame.maxX <= minX || building.frame.minX >= maxX {
                indicesToRemove.append(index)
                building.removeFromSuperview()
            }
        }
        
        for index in indicesToRemove.reversed() {
            visibleBuildings.remove(at: index)
        }
    }
    
    private func recenter() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.width) / 2.0
        let distanceFromCenter = abs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter >= bounds.width/2 {
            let moveBy = currentOffset.x - centerOffsetX
            contentOffset.x -= moveBy
            for building in visibleBuildings {
                var center = buildingContainer.convert(building.center, to: self)
                center.x -= moveBy
                building.center = convert(center, to: buildingContainer)
            }
        }

    }
    
    private func placeNewBuildingOnRight(edge: CGFloat) -> BuildingView {
        let building = BuildingView.randomBuilding()
        building.frame.origin.x = edge
        building.frame.origin.y = buildingContainer.bounds.maxY - building.frame.height
        visibleBuildings.append(building)
        buildingContainer.addSubview(building)
        return building
    }
    
    private func placeNewBuildingOnLeft(edge: CGFloat) -> BuildingView {
        let building = BuildingView.randomBuilding()
        building.frame.origin.x = edge - building.frame.width
        building.frame.origin.y = buildingContainer.bounds.maxY - building.frame.height
        visibleBuildings.insert(building, at: 0)
        buildingContainer.addSubview(building)
        return building
    }
}
