//
//  ChipMultipleSelectionCollectionViewCell.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import UIKit

final class FacilitySelectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var vwRounded: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var closure: ((_ option: Options?) -> ())? = nil
    var viewModel: FacilitySelectionCollectionViewCellVM!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cellConfig(option: Options?) {
        viewModel = FacilitySelectionCollectionViewCellVM(option: option)
        setUI()
    }
    
    private func setUI() {
        vwRounded.layer.cornerRadius = 8.0
        vwRounded.layer.borderWidth = 1.0
        vwRounded.layer.borderColor =  viewModel.isSelected ? UIColor.brown.cgColor : UIColor.gray.cgColor
        lblTitle.textColor =  viewModel.isSelected ? UIColor.brown : UIColor.black
        lblTitle.text = viewModel.name
        imgProperty.image = UIImage(named: viewModel.icon)
    }
    
    @IBAction func btnActionSelect(_ sender: UIButton) {
        if viewModel.isSelected {
            viewModel.isSelected = false
            closure?(viewModel.option)
        } else {
            viewModel.isSelected = true
            closure?(viewModel.option)
        }
    }
}
