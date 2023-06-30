//
//  SurveyCommonHeaderReusableView.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import UIKit

class CommonHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet private weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String?) {
        lblTitle.text = title
    }
}
