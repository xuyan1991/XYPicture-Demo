//
//  ViewController.swift
//  Pictures
//
//  Created by 徐岩 on 16/3/17.
//  Copyright © 2016年 xuyan. All rights reserved.
//

import UIKit
import Material
import AVFoundation
import SnapKit
import Alamofire
import Kanna
import SDWebImage
import CHTCollectionViewWaterfallLayout
import MJRefresh
import ImageViewer

class PoorManProvider: ImageProvider {
    var url: String?
    init(url: String){
        self.url = url
    }
    func provideImage(completion: UIImage? -> Void) {
        print(url)
        let urlBig = url!.stringByReplacingOccurrencesOfString("bmiddle", withString: "large")

        let imageURL = NSURL(string: urlBig)
        var nsd = NSData(contentsOfURL: imageURL!)
        var img = UIImage(data: nsd!,scale:2.0);
        completion(img)
    }
}


class ViewController:  UICollectionViewController, UINavigationControllerDelegate {
    var courses: [Dictionary<String, String>] = [Dictionary<String, String>]()

    let imageBaseUrl        = "http://www.dbmeinv.com/dbgroup/rank.htm?pager_offset="
    let pageBaseUrl         = "http://www.dbmeinv.com/dbgroup/show.htm?cid="
    var items = [Items]()
    var type: String = "3"
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    var page = 1
    private var imagePreviewer: ImageViewer!
    init(param: String, collectionViewLayout layout: UICollectionViewLayout) {
        self.type = param
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置collectionView
        getPhotos()
        print(items)
        // Attach datasource and delegate
        collectionView!.dataSource  = self
        collectionView!.delegate = self
        setupCollectionView()
        setupFootView()

    }


    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupCollectionView(){
        
        // Create a waterfall layout
        var layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        // Collection view attributes
        //collectionView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        collectionView!.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        collectionView!.collectionViewLayout = layout
        collectionView!.registerClass(XYPictureCell.self, forCellWithReuseIdentifier: "ViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
    }

    func setupFootView(){

        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        // 现在的版本要用mj_header
        collectionView!.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        collectionView!.mj_footer = footer

    }
    func getPageUrl()-> String{
        return pageBaseUrl + type + "&pager_offset=" + String(page)
    }
    func getPhotos(){
        let pageUrl = getPageUrl()
        print(pageUrl)
        Alamofire.request(.GET, pageUrl).validate().responseString{
            (request, response, result) in
            let lastPic = self.items.count
            if let doc = Kanna.HTML(html: result.value!, encoding: NSUTF8StringEncoding) {
                for link in doc.xpath("//img") {
                    print(link["title"])
                    print(link["src"])
                    //self.courses.append(["name":link["title"]!, "pic": link["src"]!])
                    var tmpItem = Items(url: link["src"]!, title: link["title"]!)
                    self.items.append(tmpItem)
                    
                }

            }
            let indexPaths = (lastPic..<self.items.count).map { NSIndexPath(forItem: $0, inSection: 0) }
            dispatch_async(dispatch_get_main_queue()) {
                //self.collectionView!
                self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                //self.collectionView!.reloadData()
            }
        }
  
        
    }

    
    // 顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        getPhotos()
        collectionView!.mj_header.endRefreshing()
        
    }
    
    // 底部刷新
    func footerRefresh(){
        print("上拉刷新")
        page = page + 1
        getPhotos()
        collectionView!.mj_footer.endRefreshing()
        // 2次后模拟没有更多数据
        
        
    }
    func showViewer(url: String) {
        
        let view = UIView()
        
        let provider = PoorManProvider(url: url)
        //var imageView = UIImageView()
        //imageView.sd_setImageWithURL(url: url, placeholderImage: <#T##UIImage!#>)
        let size = UIScreen.mainScreen().bounds.size//CGSize(width: uis, height: 1080)
        let buttonsAssets = ButtonStateAssets(normalAsset: UIImage(named: "close_normal")!, highlightedAsset: UIImage(named: "close_highlighted")!)
        
        let configuration = ImageViewerConfiguration(imageSize: size, closeButtonAssets: buttonsAssets)
        self.imagePreviewer = ImageViewer(imageProvider: provider, configuration: configuration, displacedView: view)
        self.imagePreviewer.show()
    }
    

}
extension ViewController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identtify :  String = "ViewCell"
        let cell:XYPictureCell = collectionView.dequeueReusableCellWithReuseIdentifier(identtify, forIndexPath: indexPath) as! XYPictureCell
        let imageURL = NSURL(string: items[indexPath.item].imgUrl!)
        cell.imageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "1"))
        cell.detailLabel.text = items[indexPath.item].imgTitle!

        
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        showViewer(items[indexPath.item].imgUrl!)
        //let view = DetailViewController(it: items[indexPath.item])
//        if (self.navigationController != nil) {
//            //self.navigationController!.navigationBarHidden = true
//            self.navigationController!.pushViewController(view, animated: true)
//        }
//        else{
//            print("null")
//        }
    }
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
//extension ViewController: XYLayoutDelegate{
//     func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
//                //定义NSURL对象
//        let url = NSURL(string: courses[indexPath.item]["pic"]!)
//        //从网络获取数据流
//        let data = NSData(contentsOfURL: url!)
//        //通过数据流初始化图片
//        let newImage = UIImage(data: data!)
//        let photo = UIImageView(image: newImage)
//
//        let boundingRect = CGRectMake(0, 0, width, CGFloat(MAXFLOAT))
//        let rect  = AVMakeRectWithAspectRatioInsideRect(photo.image!.size, boundingRect)
//        
//        return rect.size.height
//
//    }
//    func collectionView(collectionView: UICollectionView, heightForTextAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
//        return 44
//    }
//}

extension ViewController: CHTCollectionViewDelegateWaterfallLayout{
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
//        let url = NSURL(string: items[indexPath.item].imgUrl!)
//        //从网络获取数据流
//        let data = NSData(contentsOfURL: url!)
//        //通过数据流初始化图片
//        let newImage = UIImage(data: data!)
//        // create a cell size from the image size, and return the size
//        var imageSize = newImage!.size
//        imageSize.height = imageSize.height + 44
        let size = CGSize(width: ((UIScreen.mainScreen().bounds.width - 20)/2), height: 200.0)
        return size
    }
}

