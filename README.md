# SBHCarouselView

A Infinite Carousel Figure --Swift

Rely on SDWebImage Support local and network pictures

       let carouselView1: SBHCarouselView = SBHCarouselView.init(frame: CGRect(x: 40, y: 40, width: view.bounds.size.width - 80, height: 150), images: ["001.jpg","002.jpg","003.jpg","004.jpg","005.jpg"])
        carouselView1.autoScrollTimeInterval = 3.0
        carouselView1.didSelectItemAtIndex { (index) -> () in
            print("点击了carouselView1第\(index + 1)张图片")
        }
        view.addSubview(carouselView1)
        
        
        
        
        
        let carouselView2: SBHCarouselView = SBHCarouselView.init(frame: CGRect(x: 40, y: 200, width: view.bounds.size.width - 80, height: 150), images: ["http://img2.3lian.com/2014/f7/5/d/22.jpg","http://img2.3lian.com/2014/f7/5/d/23.jpg","http://img2.3lian.com/2014/f7/5/d/24.jpg","http://img2.3lian.com/2014/f7/5/d/25.jpg","http://img2.3lian.com/2014/f7/5/d/26.jpg","http://img2.3lian.com/2014/f7/5/d/27.jpg"])
        carouselView2.placeholderImage = UIImage.init(named: "placeholder.png")
        carouselView2.pageIndicatorTintColor = UIColor.cyanColor()
        carouselView2.currentPageIndicatorTintColor = UIColor.redColor()
        carouselView2.autoScrollTimeInterval = 5.0
        carouselView2.didSelectItemAtIndex { (index) -> () in
            print("点击了carouselView2第\(index + 1)张图片")
        }
        view.addSubview(carouselView2)
        
        
        
        
        let carouselView3: SBHCarouselView = SBHCarouselView.init(frame: CGRect(x: 40, y: 360, width: view.bounds.size.width - 80, height: 150), images: ["001.jpg","002.jpg","http://img2.3lian.com/2014/f7/5/d/22.jpg","http://img2.3lian.com/2014/f7/5/d/23.jpg","http://img2.3lian.com/2014/f7/5/d/24.jpg","003.jpg","004.jpg","005.jpg"])
        carouselView3.placeholderImage = UIImage.init(named: "placeholder.png")
        carouselView3.pageControlAliment = .Center
        carouselView3.autoScrollTimeInterval = 2.0
        carouselView3.didSelectItemAtIndex { (index) -> () in
            print("点击了carouselView3第\(index + 1)张图片")
        }
        view.addSubview(carouselView3)
        
        
<br>
![image](/1.gif)
