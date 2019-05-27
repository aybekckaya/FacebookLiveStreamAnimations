//
//  User.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 27.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit

class User {
    static let me:User = User()
    
    var profileImage:UIImage {
        return UIImage(named: "senol_gunes")!
    }
    
    init() {
        
    }
}
