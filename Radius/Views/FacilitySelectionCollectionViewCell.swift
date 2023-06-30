//
//  ChipMultipleSelectionCollectionViewCell.swift
//  Radiant
//
//  Created by Mujahid Ali on 30/06/2023.
//

import UIKit

class FacilitySelectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vwRounded: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var closure: ((_ option: Options?) -> ())? = nil
    private var option: Options?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func cellConfig(option: Options?) {
        guard let option = option else {return}
        self.option = option
        setUI()
        lblTitle.text = option.name
    }
    
    private func setUI() {
        vwRounded.layer.cornerRadius = 8.0
        vwRounded.layer.borderWidth = 1.0
        vwRounded.layer.borderColor = UIColor.purple.cgColor
        lblTitle.textColor = .black
        if let isSelected = option?.isSelected, isSelected {
            vwRounded.layer.borderColor = UIColor.brown.cgColor
            lblTitle.textColor = UIColor.brown
        } else {
            vwRounded.layer.borderColor = UIColor.gray.cgColor
            lblTitle.textColor = UIColor.black
        }
    }
    
    @IBAction func btnActionSelect(_ sender: UIButton) {
        if let isSelected = option?.isSelected, isSelected {
            option?.isSelected = false
            closure?(option)
        } else {
            option?.isSelected = true
            closure?(option)
        }
    }
}
