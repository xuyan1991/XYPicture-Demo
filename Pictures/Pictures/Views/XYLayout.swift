//
//  XYLayout.swift
//  Pictures
//
//  Created by 徐岩 on 16/3/18.
//  Copyright © 2016年 xuyan. All rights reserved.
//

import UIKit
protocol XYLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat)->CGFloat
    func collectionView(collectionView: UICollectionView, heightForTextAtIndexPath indexPath:NSIndexPath, withWidth width: CGFloat)->CGFloat
}
class XYLayoutAttributes: UICollectionViewLayoutAttributes {
    var photoHeight: CGFloat = 0.0
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as!XYLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributtes = object as? XYLayoutAttributes{
            if( attributtes.photoHeight == photoHeight) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class XYLayout: UICollectionViewLayout {
    var delegate: XYLayoutDelegate!
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    private var cache = [XYLayoutAttributes]()
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        return collectionView!.bounds.width
    }

    override class func layoutAttributesClass() -> AnyClass{
        return XYLayoutAttributes.self
    }
    override func prepareLayout() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0){
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                let textHeight = delegate.collectionView(collectionView!, heightForTextAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding + photoHeight + textHeight + cellPadding
                let frame = CGRectMake(xOffset[column], yOffset[column], columnWidth, height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                let attributes = XYLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                column = column >= (numberOfColumns - 1) ? 0: ++column
            }
            //print(collectionView!.numberOfItemsInSection(0))
            //print(cache)
        }
    }
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        //print(cache)
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
























