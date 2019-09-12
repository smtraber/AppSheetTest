//
//  LoadingHUD.swift
//  AppSheetTest
//
//  Created by Sean Traber on 9/12/19.
//  Copyright © 2019 Sean. All rights reserved.
//

import UIKit

@objcMembers
class LoadingHUD: UIView {
    
    var mainLabel: UILabel! = UILabel()
    var spinner: MMMaterialDesignSpinner! = MMMaterialDesignSpinner(frame: CGRect(origin: .zero, size: .zero))

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let background = UIView(frame: frame)
        
        self.addSubview(background)
        self.addSubview(mainLabel)
        self.addSubview(spinner)
        
        background.alpha = 0.35
        background.backgroundColor = .black
        self.backgroundColor = .clear
        
        background.translatesAutoresizingMaskIntoConstraints = false
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mainLabel.textAlignment = .center
        mainLabel.text = "Loading users..."
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        spinner.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20).isActive = true
        spinner?.tintColor = UIColor(red: 82/255, green: 115/255, blue: 249/255, alpha: 1)
        
    }
    
    func show() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        spinner?.startAnimating()
    }
    
    func hide() {
        spinner.stopAnimating()
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
