//
//  PhotoStreamViewController.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoStreamViewController: UICollectionViewController {
  
  /*var colors: [UIColor] {
    get {
      var colors = [UIColor]()
      let palette = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.yellowColor()]
      var paletteIndex = 0
      for _ in 0..<photos.count {
        colors.append(palette[paletteIndex])
        paletteIndex = paletteIndex == (palette.count - 1) ? 0 : ++paletteIndex
      }
      return colors
    }
  }*/
  var photos = Photo.allPhotos()

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let patternImage = UIImage(named: "Pattern") {
      view.backgroundColor = UIColor(patternImage: patternImage)
    }
    
    collectionView!.backgroundColor = UIColor.clearColor()
    collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
    //let size = CGRectGetWidth(collectionView!.bounds) / 2
    let layout = collectionViewLayout as! PinterestLayout
    layout.delegate = self
    layout.numberOfColumns = 2
    layout.cellPadding = 5
    //layout.itemSize = CGSize(width: size, height: size)
  }
  
}

extension PhotoStreamViewController {
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
    cell.photo = photos[indexPath.item]
    return cell
  }
  
}

extension PhotoStreamViewController : PinterestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width:CGFloat) -> CGFloat {

    let photo = photos[indexPath.item]
    //want the av method to workout the height given the constrained width -- details for using maxfloat
    let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
    let rect = AVMakeRectWithAspectRatioInsideRect(photo.image.size, boundingRect)
    
    return rect.height
  }
  
  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width:CGFloat) -> CGFloat {
    let photo = photos[indexPath.item]
    let font = UIFont(name: "AvenirNext-Regular", size: 10)
    
    let commentHeight = photo.heightForComment(font!, width: width)
    
    let height = 4 + 17 + 4 + commentHeight + 4
    
    return height
  }
  
}