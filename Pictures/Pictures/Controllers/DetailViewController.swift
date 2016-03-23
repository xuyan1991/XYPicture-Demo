//
//  DetailViewController.swift
//  Pictures
//
//  Created by 徐岩 on 16/3/23.
//  Copyright © 2016年 xuyan. All rights reserved.
//

import UIKit
import Material
import SDWebImage
import SnapKit

class DetailViewController: UIViewController {

    var item: Items?
    init(it: Items) {
        
        super.init(nibName: nil, bundle: nil)
        self.item = it
    }
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MaterialColor.white
        let imageCardView: MaterialPulseView = MaterialPulseView()
        var imageView:UIImageView = UIImageView()
        let urlBig = (item?.imgUrl)!.stringByReplacingOccurrencesOfString("bmiddle", withString: "large")
        print(urlBig)
        let imageURL = NSURL(string: urlBig)

        imageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "1"))
 


//        // Title label.
//        let titleLabel: UILabel = UILabel()
//        titleLabel.text = "Welcome Back!"
//        titleLabel.textColor = MaterialColor.white
//        titleLabel.font = RobotoFont.mediumWithSize(24)
//
//        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = item?.imgTitle!
        detailLabel.numberOfLines = 0

        
        // Yes button.
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = MaterialColor.cyan.lighten1
        btn1.pulseScale = false
        btn1.setTitle("YES", forState: .Normal)
        btn1.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
        
        // No button.
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = MaterialColor.cyan.lighten1
        btn2.pulseScale = false
        btn2.setTitle("NO", forState: .Normal)
        btn2.setTitleColor(MaterialColor.cyan.darken1, forState: .Normal)
        imageCardView.depth = .Depth2
        // Add buttons to left side.
        imageCardView.addSubview(imageView)
        imageCardView.addSubview(detailLabel)
        view.addSubview(imageCardView)
        imageCardView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top).offset(10)
            make.left.equalTo(imageView.snp_left).offset(-10)
            make.right.equalTo(imageView.snp_right).offset(10)
            make.bottom.equalTo(detailLabel.snp_bottom)
        }
        detailLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(imageCardView.snp_bottom)
            make.left.equalTo(imageCardView.snp_left).offset(10)
            make.right.equalTo(imageCardView.snp_right).offset(-10)
            make.height.equalTo(44)
        }
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imageCardView.snp_top).offset(10)
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(detailLabel.snp_top)
        }
        

        // To support orientation changes, use MaterialLayout.
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
