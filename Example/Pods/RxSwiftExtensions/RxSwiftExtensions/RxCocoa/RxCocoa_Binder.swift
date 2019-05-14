//
//  RxCocoa_Binder.swift
//  RxSwiftExtensions
//
//  Created by 윤중현 on 22/11/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import RxSwift
import RxCocoa

// Bind ObservableType extensions
extension ObservableType {
    public func bind<O: ObserverType>(to observers: [O]) -> Disposable where O.E == E {
        let shared = self.share()
        let disposables = observers.map({ shared.bind(to: $0) })
        return Disposables.create(disposables)
    }
    
    public func bind<O: ObserverType>(to observers: [O]) -> Disposable where O.E == E? {
        let shared = self.share()
        let disposables = observers.map({ shared.bind(to: $0) })
        return Disposables.create(disposables)
    }
    
    public func bind<O: ObserverType>(to observers: [O]?) -> Disposable where O.E == E {
        guard let observers = observers else { return Disposables.create() }
        return bind(to: observers)
    }
    
    public func bind<O: ObserverType>(to observers: [O]?) -> Disposable where O.E == E? {
        guard let observers = observers else { return Disposables.create() }
        return bind(to: observers)
    }
    
    public func bind<O: ObserverType>(to observer: O?) -> Disposable where O.E == E {
        guard let observer = observer else { return Disposables.create() }
        return bind(to: observer)
    }
    
    public func bind<O: ObserverType>(to observer: O?) -> Disposable where O.E == E? {
        guard let observer = observer else { return Disposables.create() }
        return bind(to: observer)
    }
}

// Bind BehaviorRelay extensions
extension ObservableType {
    public func bind(to relaies: [BehaviorRelay<E?>]) -> Disposable {
        let shared = self.share()
        let disposables = relaies.map({ shared.bind(to: $0) })
        return Disposables.create(disposables)
    }
    
    public func bind(to relaies: [BehaviorRelay<E>]) -> Disposable {
        let shared = self.share()
        let disposables = relaies.map({ shared.bind(to: $0) })
        return Disposables.create(disposables)
    }
    
    public func bind(to relaies: [BehaviorRelay<E>]?) -> Disposable {
        guard let relaies = relaies else { return Disposables.create() }
        return bind(to: relaies)
    }
    
    public func bind(to relaies: [BehaviorRelay<E?>]?) -> Disposable {
        guard let relaies = relaies else { return Disposables.create() }
        return bind(to: relaies)
    }
    
    public func bind(to relay: BehaviorRelay<E>?) -> Disposable {
        guard let relay = relay else { return Disposables.create() }
        return bind(to: relay)
    }
    
    public func bind(to relay: BehaviorRelay<E?>?) -> Disposable {
        guard let relay = relay else { return Disposables.create() }
        return bind(to: relay)
    }
}

// Bind PublishRelay extensions
extension ObservableType {
    public func bind(to relaies: [PublishRelay<E>]) -> Disposable {
        let shared = self.share()
        let disposables = relaies.map({ shared.bind(to: $0) })
        return Disposables.create(disposables)
    }

    public func bind(to relaies: [PublishRelay<E?>]) -> Disposable {
        let shared = self.share()
        let disposables = relaies.map({ shared.bind(to: $0) })
        return Disposables.create(disposables)
    }

    public func bind(to relaies: [PublishRelay<E>]?) -> Disposable {
        guard let relaies = relaies else { return Disposables.create() }
        return bind(to: relaies)
    }

    public func bind(to relaies: [PublishRelay<E?>]?) -> Disposable {
        guard let relaies = relaies else { return Disposables.create() }
        return bind(to: relaies)
    }

    public func bind(to relay: PublishRelay<E>?) -> Disposable {
        guard let relay = relay else { return Disposables.create() }
        return bind(to: relay)
    }

    public func bind(to relay: PublishRelay<E?>?) -> Disposable {
        guard let relay = relay else { return Disposables.create() }
        return bind(to: relay)
    }
}
