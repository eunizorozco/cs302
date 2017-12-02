//
//  GridViewController.swift
//  StatisticsCalculator
//
//  Created by Eunice Orozco on 01/12/2017.
//  Copyright © 2017 TIP. All rights reserved.
//

import UIKit

struct GridManager {
    
    static var shared = GridManager()
    var numberOfData: Int = 10
    
    lazy var dataY: [Int: Double] = [:]
    lazy var dataX: [Int: Double] = [:]
}

class GridViewController: UIViewController {

    var keyboardToolbar: UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self.view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        return keyboardToolbar
    }
}

extension GridViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GridManager.shared.numberOfData
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = indexPath.row == 0 ? "labelCell": "inputCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? GridCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.nameLabel?.text = "\(indexPath.section + 1)"
        cell.inputTextField?.tag = indexPath.row + (indexPath.section * 10)
        cell.inputTextField?.inputAccessoryView = keyboardToolbar
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if indexPath.row > 0 {
            return CGSize(width: width * 0.4, height: 25)
        }
        return CGSize(width: width * 0.2, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section > 0 ? CGSize.zero : CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = kind == UICollectionElementKindSectionHeader ? "header": "footer"
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}

extension GridViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let input = textField.text, let num = Double(input) else { return textField.text = "" }
        let section = textField.tag / 10
        if textField.tag % 2 == 0 { // Then it is Y
            GridManager.shared.dataY[section] = num
        } else {
            GridManager.shared.dataX[section] = num
        }
    }
}

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var inputTextField: UITextField?
    
}


