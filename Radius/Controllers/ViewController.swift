//
//  ViewController.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let facilityViewModel = FacilityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "FacilitySelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FacilitySelectionCollectionViewCell")
        collectionView.register(UINib(nibName: "CommonHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommonHeaderReusableView")
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        facilityViewModel.fetchFacilities { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {[weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil}
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .estimated(40))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
                group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8.0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                section.interGroupSpacing = 8
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            }
        }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

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
        guard let option = facilityViewModel.getFacilityOption(index: indexPath.row, section: indexPath.section) else {
            fatalError("Not found")
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilitySelectionCollectionViewCell", for: indexPath) as? FacilitySelectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.cellConfig(option: option)
        cell.closure = { [weak self] option in
            guard let self = self else {
                return
            }
            if self.facilityViewModel.isNotAllowedToSelect(faciltyId: self.facilityViewModel.getFacilityId(at: indexPath.section) ?? "", optionId: option?.id ?? "") {
                return
            }
            
            if let unwarppedOption = option {
                self.facilityViewModel.updateOption(at: indexPath.section, at: indexPath.row, optionToUpdate: unwarppedOption)
                DispatchQueue.main.async {
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard self.facilityViewModel.numberOfFacilities > indexPath.section else { return UICollectionReusableView() }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommonHeaderReusableView", for: indexPath) as! CommonHeaderReusableView
            let facility = self.facilityViewModel.getFacility(at: indexPath.section)
            header.configure(title: facility?.name)
            return header
        default:
            fatalError("fatal error")
        }
    }
}

