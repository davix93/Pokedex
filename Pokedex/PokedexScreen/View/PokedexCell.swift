//
//  PokedexTableViewCell.swift
//  Pokedex
//
//  Created by Davide Tarantino on 27/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation
import UIKit
import PinLayout
import Kingfisher

class PokedexCell: UITableViewCell, PokeView {
    
    static let reuseIdentifier = "PokedexTableViewCell"
    let padding: CGFloat = 20
    
    var backgroundCell = UIView()
    var nameLabel = UILabel()
    var numberLabel = UILabel()
    var sprite = UIImageView()
    
    var cellModel: PokedexCellModel?{
        didSet{
            self.update()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
        self.style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.sprite.image = nil
    }
    
    func setup() {
        self.contentView.addSubview(self.backgroundCell)
        self.backgroundCell.addSubview(self.nameLabel)
        self.backgroundCell.addSubview(self.numberLabel)
        self.backgroundCell.addSubview(self.sprite)
    }
    
    func style() {
        self.selectionStyle = .none
        
        self.nameLabel.textColor = .black
        self.nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        self.numberLabel.textColor = .black
        self.numberLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        self.backgroundCell.backgroundColor = .white
        self.backgroundCell.layer.cornerRadius = 16
        
        self.contentView.backgroundColor = pokedexColor
        
    }
    
    func update() {
        guard let model = self.cellModel else {return}
        self.nameLabel.text = model.name
        self.numberLabel.text = "#\(model.number)"
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func layout() {
        
        self.sprite.pin
            .left(5%)
            .width(60)
            .height(60)
            .vCenter()

        self.numberLabel.pin
            .after(of: self.sprite, aligned: .center)
            .marginLeft(4%)
            .sizeToFit()
        
        self.nameLabel.pin
            .after(of: self.numberLabel, aligned: .center)
            .marginLeft(2%)
            .sizeToFit()
        
        self.backgroundCell.pin
            .horizontally(4%)
            .wrapContent(.vertically, padding: 5)
        
        self.contentView.pin
            .wrapContent(.vertically, padding: 5)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.pin.width(size.width)
        self.layout()
        return CGSize(width: self.contentView.frame.width, height: self.contentView.frame.maxY)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.contentView.backgroundColor = highlighted ? selectedColor : pokedexColor
    }
    

}


struct PokedexCellModel {
    var name: String
    var number: String
}
