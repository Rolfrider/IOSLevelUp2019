//
//  NetworkActivityIndicatorAdapter.swift
//  Joker
//
//  Created by Rafał Kwiatkowski on 05/04/2019.
//  Copyright © 2019 DaftAcademy. All rights reserved.
//

import Foundation
import UIKit


protocol NetworkActivityIndicatorAdapting {
    func networkActivityIndicator(isVisible: Bool)
}


class NetworkActivityIndicatorAdapter: NetworkActivityIndicatorAdapting {
    
    func networkActivityIndicator(isVisible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
    }
}
