//
//  ViewController.swift
//  Radius
//
//  Created by Mujahid Ali on 30/06/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var facilityViewModel: FacilityViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facilityViewModel = FacilityViewModel()
        collectionView.register(UINib(nibName: "FacilitySelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FacilitySelectionCollectionView")
        collectionView.register(UINib(nibName: "CommonHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommonHeaderReusableView")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
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

