//
//  NetAdpIndicatorSpy.swift
//  JokerTests
//
//  Created by Rafał Kwiatkowski on 05/04/2019.
//  Copyright © 2019 DaftAcademy. All rights reserved.
//

import Foundation
@testable import Joker

class NetActIndicatorAdapterSpy: NetworkActivityIndicatorAdapting {
    
    
    var isNetworActivitiIndicatorVisible = false
    
    func networkActivityIndicator(isVisible: Bool){
        isNetworActivitiIndicatorVisible = isVisible
    }
    
    
}
