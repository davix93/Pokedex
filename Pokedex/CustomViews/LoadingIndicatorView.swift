//
//  LoadingIndicatorView.swift
//  Pokedex
//
//  Created by Davide Tarantino on 29/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//
import UIKit
import PinLayout

class LoadingIndicatorView: UIView, PokeView {
    
    
    let imageView = UIImageView()
    let image: UIImage
    
    init(frame: CGRect, image: UIImage) {
        self.image = image
        
        super.init(frame: frame)
        
        self.setup()
        self.style()
        
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        self.imageView.image = self.image
        self.addSubview(imageView)
        
        self.isUserInteractionEnabled = false
    }
    
    func style() {
        self.backgroundColor = .clear
    }
    
    func layout() {
        self.imageView.pin
            .center()
            .width(20%)
            .aspectRatio(1)
    }
//
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
    
    func startAnimating() {
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.alpha = 1
        }, completion: { _ in
            self.rotate()
        })
    }
    
    func stopAnimating(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.alpha = 0
        },completion: { _ in
            self.removeRotation()
            completion()
        })
    }
    
    private func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func removeRotation() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}
