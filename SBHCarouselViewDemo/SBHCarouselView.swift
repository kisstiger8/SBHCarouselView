//
//  SBHCarouselView.swift
//  SBHCarouselViewDemo
//
//  Created by 宋碧海 on 16/1/13.
//  Copyright © 2016年 songbihai. All rights reserved.
//
import UIKit

enum SBHPageControlAliment {
    case Center
    case Right
}

struct RegexHelper {
    var regex: NSRegularExpression?
    init(_ pattern: String) {
        do {
            regex = try NSRegularExpression(pattern: pattern,
                options: .CaseInsensitive)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
            options: NSMatchingOptions.ReportCompletion,
            range: NSMakeRange(0, input.characters.count)) {
                return matches.count > 0
        } else {
            return false
        }
    }
}

class SBHCarouselViewCell: UICollectionViewCell {
    var imageV: UIImageView
    
    override init(frame: CGRect) {
        imageV = UIImageView.init(frame: CGRect(origin: CGPointZero, size: frame.size))
        imageV.contentMode = .ScaleAspectFill
        super.init(frame: frame)
        addSubview(imageV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SBHCarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
// MARK: property -- private
    private let cell_Id = "cell_Identifier"
    private var collectionView:UICollectionView!
    private var flowLayout:UICollectionViewFlowLayout!
    private var timer:NSTimer?
    private var pageControl:UIPageControl?
    private var selectedWithIndex: ((index:NSInteger) -> ())?
// MARK: property -- internal
    //图片数组，可以是图片名字，可以是URL
    var images:[NSString]
    
    //自动滚动的时间间隔，默认4s
    var autoScrollTimeInterval:NSTimeInterval! {
        didSet {
            if let _ = timer {
                timer!.invalidate()
                timer = nil
            }
            setupTimer()
        }
    }
    
    //是否自动滚动，默认true
    var autoScroll:Bool! {
        didSet {
            if autoScroll == true {
            if let _ = timer {
                timer!.invalidate()
                timer = nil
            }
                setupTimer()
            }else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    //是否显示分页控件，默认true
    var showPageControl:Bool! {
        didSet {
            pageControl?.hidden = !showPageControl
        }
    }
    
    //占位图
    var placeholderImage:UIImage?
    
    //分页控件的位置，默认居中（.Center）
    var pageControlAliment: SBHPageControlAliment = .Center {
        didSet {
            switch pageControlAliment {
            case .Center: pageControl!.frame = CGRect(x: bounds.size.width / 4 , y: bounds.size.height - 30, width: bounds.size.width / 2, height: 30)
            case .Right: pageControl!.frame = CGRect(x: bounds.size.width / 2 , y: bounds.size.height - 30, width: bounds.size.width / 2, height: 30)
            }
        }
    }
    
    //UIPageControl的颜色，默认灰色
    var pageIndicatorTintColor:UIColor! {
        didSet {
            pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    ////UIPageControl当前page的颜色，默认白色
    var currentPageIndicatorTintColor:UIColor! {
        didSet {
            pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
// MARK: init - method
    init(frame: CGRect, images:[NSString]) {
        self.images = images
        super.init(frame: frame)
        initialization()
        setupCollectionView()
        setupPageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: override（重写）
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
        setupCollectionView()
        setupPageControl()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = frame.size
        collectionView.frame = bounds
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if (newSuperview == nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
// MARK: private - method
    private func initialization() {
        autoScrollTimeInterval = 4.0
        autoScroll = true
        showPageControl = true
        pageIndicatorTintColor = UIColor.grayColor()
        currentPageIndicatorTintColor = UIColor.whiteColor()
    }
    
    private func setupCollectionView(){
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = self.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        
        collectionView = UICollectionView.init(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(SBHCarouselViewCell.self, forCellWithReuseIdentifier: cell_Id)
        self.addSubview(collectionView)
    }
    
    private func setupPageControl() {
        pageControl = UIPageControl.init()
        pageControl!.numberOfPages = images.count
        pageControl!.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl!.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl!.frame = CGRect(x: bounds.size.width / 4 , y: bounds.size.height - 30, width: bounds.size.width / 2, height: 30)
        addSubview(pageControl!)
        collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
    }
    
    private func setupTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(autoScrollTimeInterval, target: self, selector: Selector("automaticScroll"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    @objc private func automaticScroll() {
        var index: Int = Int(collectionView.contentOffset.x / flowLayout.itemSize.width)
        index += 1
        collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
    }
    
// MARK: UICollectionView -- DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //+2实现无限循环
        return images.count + 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:SBHCarouselViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cell_Id, forIndexPath: indexPath) as! SBHCarouselViewCell
        let regex: String = "[a-zA-z]+://[^\\s]*"
        let matcher: RegexHelper = RegexHelper(regex)
        if indexPath.row == 0 {
            if matcher.match(images[images.count - 1] as String) {
                cell.imageV.sd_setImageWithURL(NSURL.init(string: images[images.count - 1] as String), placeholderImage: placeholderImage)
            }else{
                cell.imageV.image = UIImage.init(named: images[images.count - 1] as String)
            }
        }else if indexPath.row == images.count + 1 {
            if matcher.match(images[0] as String) {
                cell.imageV.sd_setImageWithURL(NSURL.init(string: images[0] as String), placeholderImage: placeholderImage)
            }else{
                cell.imageV.image = UIImage.init(named: images[0] as String)
            }
        }else if indexPath.row <= images.count {
        if matcher.match(images[indexPath.row - 1] as String) {
            cell.imageV.sd_setImageWithURL(NSURL.init(string: images[indexPath.row - 1] as String), placeholderImage: placeholderImage)
        }else{
            cell.imageV.image = UIImage.init(named: images[indexPath.row - 1] as String)
        }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if selectedWithIndex != nil {
            if (indexPath.row != images.count + 1) && (indexPath.row != 0) {
            selectedWithIndex!(index: indexPath.row - 1)
            }
        }
    }
    
// MARK: UICollectionView -- delegate
    func didSelectItemAtIndex(selected: (index:NSInteger) -> ()) {
        selectedWithIndex = selected
    }
    
// MARK: UIScrollViewDelegate -- method
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var index: Int = Int(scrollView.contentOffset.x / flowLayout.itemSize.width)
        if index == images.count + 1 {
            collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
            index = 1
        }else if scrollView.contentOffset.x <= 0 {
            collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: images.count, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
            index = images.count
        }
        pageControl!.currentPage = index - 1
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScroll! {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll! {
            if timer == nil {
               setupTimer()
            }
        }
    }
    
}

