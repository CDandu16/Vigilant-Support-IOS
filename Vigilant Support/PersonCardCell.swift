//
//  PersonCardCell.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 7/16/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit

class PersonCardCell : UITableViewCell{
    //MARK: Properties
    
   
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Email: UIButton!
    @IBOutlet weak var Call: UIButton!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var sms: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var overallCell: UIView!
    @IBOutlet weak var thumbNail: UIImageView!
    
    override func layoutSubviews() {
        self.cardSetup()
        self.imageSetup()
    }
    
    func cardSetup(){
        self.cardView.alpha = CGFloat(1)
        self.cardView.layer.masksToBounds = false;
        self.cardView.layer.cornerRadius = 1;
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        self.cardView.layer.shadowRadius = 1;
        self.cardView.layer.shadowPath = UIBezierPath(rect:self.cardView.bounds).CGPath
        self.cardView.layer.shadowOpacity = 0.2;
        self.overallCell.backgroundColor = UIColor(red: 0.9,green: 0.9,blue: 0.9, alpha: 1)
    
    }
    
    func imageSetup(){
//        self.thumbNail.layer.borderWidth = 2.0;
//        self.thumbNail.layer.borderColor = UIColor.blackColor().CGColor
        self.thumbNail.layer.cornerRadius = 50;
        self.thumbNail.clipsToBounds = true;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}