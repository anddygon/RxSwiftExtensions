//
//  Reactive+ViewController.swift
//  AllLive
//
//  Created by xiaoP on 2017/11/23.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

public extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .mapVoid()
    }
    
    var viewDidAppear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .mapVoid()
    }
    
    var viewWillDisappear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .mapVoid()
    }
    
    var viewDidDisappear: Observable<Void> {
        return base.rx.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .mapVoid()
    }
    
    var touchBegan: Observable<(Set<UITouch>, UIEvent?)> {
        return base.rx.methodInvoked(#selector(UIViewController.touchesBegan(_:with:)))
            .map({ (params) -> (Set<UITouch>, UIEvent?) in
                return (params[0] as! Set<UITouch>, params[1] as? UIEvent)
            })
    }
    
    var touchMoved: Observable<(Set<UITouch>, UIEvent?)> {
        return base.rx.methodInvoked(#selector(UIViewController.touchesMoved(_:with:)))
            .map({ (params) -> (Set<UITouch>, UIEvent?) in
                return (params[0] as! Set<UITouch>, params[1] as? UIEvent)
            })
    }
    
    var touchEnded: Observable<(Set<UITouch>, UIEvent?)> {
        return base.rx.methodInvoked(#selector(UIViewController.touchesEnded(_:with:)))
            .map({ (params) -> (Set<UITouch>, UIEvent?) in
                return (params[0] as! Set<UITouch>, params[1] as? UIEvent)
            })
    }
    
    var touchCancelled: Observable<(Set<UITouch>, UIEvent?)> {
        return base.rx.methodInvoked(#selector(UIViewController.touchesCancelled(_:with:)))
            .map({ (params) -> (Set<UITouch>, UIEvent?) in
                return (params[0] as! Set<UITouch>, params[1] as? UIEvent)
            })
    }
}
