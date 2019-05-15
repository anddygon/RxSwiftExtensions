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
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).mapVoid()
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).mapVoid()
        return ControlEvent(events: source)
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).mapVoid()
        return ControlEvent(events: source)
    }
    
    var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    /// Rx observable, triggered when the ViewController appearance state changes (true if the View is being displayed, false otherwise)
    var isVisible: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }
    
    /// Rx observable, triggered when the ViewController is being dismissed
    var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
