//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Marquis Dennis on 1/5/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

//set up delegate protocol for layout
protocol PinterestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayoutAttributes : UICollectionViewLayoutAttributes {
  //custom property
  var photoHeight: CGFloat = 0
  
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone) as! PinterestLayoutAttributes
    copy.photoHeight = photoHeight
    
    return copy
  }
  
  override func isEqual(object: AnyObject?) -> Bool {
    if let attributes = object as? PinterestLayoutAttributes {
      if attributes.photoHeight == photoHeight {
        return super.isEqual(object)
      }
    }
    
    return false
  }
}

class PinterestLayout : UICollectionViewLayout {
  
  var delegate : PinterestLayoutDelegate!
  var numberOfColumns = 1
  var cellPadding:CGFloat = 0
  
  //layout attributes are what is created and passed back to the collection view
  //the collection view takes the attributes and works out the layouts of the frames of all the items
  //cache the layout attributes so they can only will be created once
  //when the collection view asks for the layout attributes they can access the cache
  //private var cache = [UICollectionViewLayoutAttributes]()
  private var cache = [PinterestLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  
  //height of the content of the collection view
  private var width: CGFloat {
    return CGRectGetWidth(collectionView!.bounds) - (collectionView!.contentInset.left + collectionView!.contentInset.right)
  }
  
  override class func layoutAttributesClass() -> AnyClass {
    return PinterestLayoutAttributes.self
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: width, height: contentHeight)
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    for attributes in cache {
      if CGRectIntersectsRect(attributes.frame, rect) {
        layoutAttributes.append(attributes)
      }
    }
    
    return layoutAttributes
  }
  
  //called whenever a layout operation is called on the collection view
  override func prepareLayout() {
    if cache.isEmpty {
      let columnWidth = width / CGFloat(numberOfColumns)
      
      var xOffsets = [CGFloat]()
      
      //x offset for each column
      for column in 0..<numberOfColumns {
        xOffsets.append(CGFloat(column) * columnWidth)
      }
      
      var yOffSets = [CGFloat](count: numberOfColumns, repeatedValue: 0)
      
      //current column implementation
      var column = 0
      
      for item in 0..<collectionView!.numberOfItemsInSection(0) {
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        //let height = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath)
        let width = columnWidth - cellPadding * 2
        let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
        let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
        
        let height = cellPadding + photoHeight + annotationHeight + cellPadding
        
        let frame = CGRect(x: xOffsets[column], y: yOffSets[column], width: columnWidth, height: height)
        
        let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        
        //let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let attributes = PinterestLayoutAttributes(forCellWithIndexPath: indexPath)
        //attributes.frame = frame
        attributes.frame = insetFrame
        attributes.photoHeight = photoHeight
        cache.append(attributes)
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffSets[column] = yOffSets[column] + height
        column = column >= (numberOfColumns - 1) ? 0 : ++column
      }
    }
  }
}
