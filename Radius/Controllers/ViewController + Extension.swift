//
//  ViewController + Extension.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return facilityViewModel.numberOfFacilities
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilityViewModel.numberOfFacilityOptions(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard facilityViewModel.numberOfFacilityOptions(at: indexPath.section) > indexPath.row else {
            fatalError("Not found")
        }
        guard let facilitiesOption = facilityViewModel.getFacilityOption(index: indexPath.row, section: indexPath.section) else {
            fatalError("Not found")
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilitySelectionCollectionView", for: indexPath) as? FacilitySelectionCollectionViewCell else {
            fatalError("Not found")
        }
        cell.cellConfig(option: facilitiesOption)
        cell.closure = { [weak self] option in
            guard let self = self else {
                return
            }
            if self.facilityViewModel.isNotAllowedToSelect(faciltyId: self.facilityViewModel.getFacilityId(at: indexPath.section) ?? "", optionId: option?.id ?? "") {
                return
            }
            
            if let unwarppedOption = option {
                self.facilityViewModel.updateOption(at: indexPath.section, at: indexPath.row, optionToUpdate: unwarppedOption)
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard self.facilityViewModel.numberOfFacilities > indexPath.section else { return UICollectionReusableView() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommonHeaderReusableView", for: indexPath) as? CommonHeaderReusableView else {
                return UICollectionReusableView()
            }
            let facility = self.facilityViewModel.getFacility(at: indexPath.section)
            header.configure(title: facility?.name)
            return header
        default:
            fatalError("fatal error")
        }
    }
}
