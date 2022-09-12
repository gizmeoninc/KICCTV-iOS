//
//  SubscriptionListTableViewCell.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 10/07/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit


class subscriptionListTableViewCell: UICollectionViewCell{
    lazy var subscriptionDetailsLabel:UILabel = {
        let label = UILabel()
        label.text = " "
        label.numberOfLines = 2;
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }()
    lazy var subscriptionDateLabel:UILabel = {
           let label = UILabel()
           label.text = " "
           return label
       }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    func setupView(){
        addSubview(subscriptionDetailsLabel)
        addSubview(subscriptionDateLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0(350)]", views: subscriptionDetailsLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: subscriptionDateLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]-16-[v1]", views: subscriptionDetailsLabel,subscriptionDateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// constraints to dictionory
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionory = [String: UIView]()
        for(index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionory[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionory));
    }
}



//class SubscriptionListTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var subscriptionNameLabel: UILabel!
//    @IBOutlet weak var subscriptionValidityLabel: UILabel!
//    @IBOutlet weak var subscriptionType: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var selectionButton: UIButton!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        // Initialization code
//    }
//
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}

