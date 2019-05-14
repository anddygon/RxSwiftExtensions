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

public extension Reactive where Base: UIViewController {
    /**
     If the object is reporting a different class then what it's real class, that means that there is probably
     already some interception mechanism in place or something weird is happening.
     
     Most common case when this would happen is when using KVO (`observe`) and `sentMessage`.
     This error is easily resolved by just using `sentMessage` observing before `observe`.
     
     The reason why other way around could create issues is because KVO will unregister it's interceptor
     class and restore original class. Unfortunately that will happen no matter was there another interceptor
     subclass registered in hierarchy or not.
     
     Failure scenario:
     * KVO sets class to be `__KVO__OriginalClass` (subclass of `OriginalClass`)
     * `sentMessage` sets object class to be `_RX_namespace___KVO__OriginalClass` (subclass of `__KVO__OriginalClass`)
     * then unobserving with KVO will restore class to be `OriginalClass` -> failure point
     The reason why changing order of observing works is because any interception method should return
     object's original real class (if that doesn't happen then it's really easy to argue that's a bug
     in that other library).
     
     This library won't remove registered interceptor even if there aren't any observers left because
     it's highly unlikely it would have any benefit in real world use cases, and it's even more
     dangerous.
     */
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
