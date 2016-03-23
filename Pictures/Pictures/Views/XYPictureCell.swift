//
//  XYPictureCell.swift
//  Pictures
//
//  Created by 徐岩 on 16/3/21.
//  Copyright © 2016年 xuyan. All rights reserved.
//
import UIKit
import Material
import SnapKit

class XYPictureCell: UICollectionViewCell {
    var imageView: UIImageView = UIImageView()
    let cellView: MaterialPulseView = MaterialPulseView()
    var detailLabel: UILabel = UILabel()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //imageView.contentMode = .ScaleAspectFill
        detailLabel.numberOfLines = 0
        detailLabel.font = RobotoFont.mediumWithSize(13)
        cellView.addSubview(imageView)
        cellView.addSubview(detailLabel)
        contentView.addSubview(cellView)
        cellView.depth = .Depth3
        cellView.frame = contentView.frame
        detailLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cellView.snp_bottom)
            make.left.equalTo(cellView.snp_left).offset(10)
            make.right.equalTo(cellView.snp_right).offset(-10)
            make.height.equalTo(44)
        }
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cellView.snp_top)
            make.width.equalTo(cellView.snp_width)
            make.bottom.equalTo(detailLabel.snp_top)
        }
    }
}