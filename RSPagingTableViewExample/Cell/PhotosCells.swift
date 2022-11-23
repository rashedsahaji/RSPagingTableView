//
//  PhotosCells.swift
//  RSPagingTableViewExample
//
//  Created by Rashed Sahajee on 21/11/22.
//

import UIKit

class PhotosCells: UITableViewCell {
    
    static let identifier: String = "PhotosCells"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
