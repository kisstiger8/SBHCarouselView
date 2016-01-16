# SBHCarouselView

A Infinite Carousel Figure --Swift

Rely on SDWebImage Support local and network pictures

let carouselView: SBHCarouselView = SBHCarouselView.init(frame: CGRect(x: 40, y: 360, width: view.bounds.size.width - 80, height: 150), images: ["001.jpg","002.jpg","http://img2.3lian.com/2014/f7/5/d/22.jpg","http://img2.3lian.com/2014/f7/5/d/23.jpg","http://img2.3lian.com/2014/f7/5/d/24.jpg","003.jpg","004.jpg","005.jpg"])
        carouselView.placeholderImage = UIImage.init(named: "placeholder.png")
        carouselView.pageControlAliment = .Center
        carouselView.autoScrollTimeInterval = 2.0
        carouselView.didSelectItemAtIndex { (index) -> () in
            print("点击了carouselView第\(index + 1)张图片")
        }
        view.addSubview(carouselView)
