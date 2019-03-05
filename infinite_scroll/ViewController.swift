//
//  ViewController.swift
//  infinite_scroll
//
//  Created by Viktor on 3/6/19.
//  Copyright © 2019 vm. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(red: UInt, green: UInt, blue: UInt, a: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    convenience init(rgb: UInt, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: UInt.random(in: 0...255), green: UInt.random(in: 0...255), blue: UInt.random(in: 0...255))
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var scrollTimer: Timer?
    var scrollPaused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    @objc func timerAction() {
        if scrollPaused { return }
        self.collectionView.contentOffset.x += 1
//        print("scroll \(self.collectionView.contentOffset.x)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    //UICollectionViewDataSource
    
    var realItems: [UIColor] = [.random, .random, .random, .random, .random]
    let maxCount = 10000
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.item >= maxCount - 1 {
            self.collectionView.contentOffset = .zero
        }
        
        cell.backgroundView = UIView()
        
        let index = indexPath.item % realItems.count
        cell.backgroundView?.backgroundColor = realItems[index]

        print(indexPath)
        return cell
    }
    
    //UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = UIViewController()
        let cell = collectionView.cellForItem(at: indexPath)
        
        detail.view.backgroundColor = cell?.backgroundView?.backgroundColor
        
        self.scrollTimer?.invalidate()
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    //UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

