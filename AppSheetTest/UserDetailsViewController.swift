//
//  UserDetailsViewController.swift
//  AppSheetTest
//
//  Created by Sean Traber on 9/11/19.
//  Copyright © 2019 Sean. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var userID: Int?
    var selectedUser: User?
    var spinner: MMMaterialDesignSpinner?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let id = userID else { return }
        
        title = "User ID: \(id)"
        
        //Don't continue if the user was not set when pushing this view
        guard let user = selectedUser else { return }
        
        photoImageView.layer.borderColor = UIColor.black.cgColor
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.cornerRadius = 64
        
        nameLabel.text = user.name
        ageLabel.text = String(user.age)
        phoneLabel.text = user.number
        bioTextView.text = user.bio
        
        spinner = MMMaterialDesignSpinner(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.addSubview(spinner!)
        spinner?.translatesAutoresizingMaskIntoConstraints = false
        spinner?.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor).isActive = true
        spinner?.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        spinner?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        spinner?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        spinner?.tintColor = UIColor(red: 82/255, green: 115/255, blue: 249/255, alpha: 1)
        spinner?.startAnimating()
        
        performSelector(inBackground: #selector(loadImage), with: nil)
        
    }
    
    @objc func loadImage() {
        
        guard let user = selectedUser else { return }
        
        //attempt to download the image from the url provided and set it in our image view
        if let url = URL(string: user.photo) {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [unowned self] in
                    self.spinner?.stopAnimating()
                    self.photoImageView.image = UIImage(data: data)
                }
            }
        }
    }

}
