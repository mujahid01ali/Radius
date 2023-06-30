//
//  FacilitySelectionCollectionViewCellVM.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import Foundation

final class FacilitySelectionCollectionViewCellVM {
    var option: Options?
    
    init(option: Options?) {
        self.option = option
    }
    
    var name: String? {
        return option?.name
    }
    
    var icon: String {
        return option?.icon ?? ""
    }
    
    var isSelected: Bool {
        get {
            return option?.isSelected ?? false
        } set {
            option?.isSelected = newValue
        }
    }
}
