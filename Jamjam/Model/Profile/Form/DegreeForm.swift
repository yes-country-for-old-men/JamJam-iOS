//
//  DegreeFormModel.swift
//  Jamjam
//
//  Created by 권형일 on 7/5/25.
//

import SwiftUI

struct DegreeForm: Identifiable {
    var schoolName = ""
    var major = ""
    var degree = ""
    var fileData: [UIImage]?
    
    let id = UUID() // Identifiable
}
