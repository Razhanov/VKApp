//
//  ProfilePhotoCell.swift
//  Weather
//
//  Created by Karim Razhanov on 05/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit

class ProfilePhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView! {
        didSet {
            profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var photoText: UILabel! {
        didSet {
            photoText.translatesAutoresizingMaskIntoConstraints = false
            photoText.numberOfLines = 3
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let insets: CGFloat = 10.0
    
    func setPhotoText(text: String) {
        photoText.text = text
        photoTextLabelFrame()
    }
//    func setProfilePhoto(image: UIImage) {
//        profilePhoto.image = image
//        profilePhotoFrame()
//    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - insets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func photoTextLabelFrame() {
        let photoTextLabelSize = getLabelSize(text: photoText.text!, font: photoText.font)
        let photoTextLabelX = (bounds.width - photoTextLabelSize.width)/2
        let photoTextLabelOrigin = CGPoint(x: photoTextLabelX, y: insets)
        photoText.frame = CGRect(origin: photoTextLabelOrigin, size: photoTextLabelSize)
    }
//    func getImageSize() -> CGSize {
//        let maxWidth = bounds.width - insets * 2
//        let maxHeight: Float = 275.0
//        let size = CGSize(width: ceil(maxWidth), height: CGFloat(ceil(maxHeight)))
//        return size
//    }
    func profilePhotoFrame() {
        //let profilePhotoSideLinght: CGFloat = 100
        let profilePhotoSize = CGSize(width: bounds.width - insets * 2, height: 275.0)
        let profilePhotoOrigin = CGPoint(x: bounds.midX - bounds.width / 2, y: bounds.midY - 137.5)
        profilePhoto.frame = CGRect(origin: profilePhotoOrigin, size: profilePhotoSize)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoTextLabelFrame()
        profilePhotoFrame()
    }
    
    
}











