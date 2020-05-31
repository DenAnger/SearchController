//
//  DetailViewController.swift
//  SearchController
//
//  Created by Denis Abramov on 26.05.2020.
//  Copyright © 2020 Denis Abramov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var candyLabel: UILabel!
    @IBOutlet var candyImage: UIImageView!
    
    var candy: Candy? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        if let candy = candy,
        let candyLabel = candyLabel,
            let candyImage = candyImage {
            candyLabel.text = candy.name
            candyImage.image = UIImage(named: candy.name)
            title = candy.category.rawValue
        }
    }
}
