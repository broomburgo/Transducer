
import Foundation

public struct Transducer<Accumulator,Element1,Element2>
{
  public let apply: ((Accumulator,Element2) -> Accumulator) -> ((Accumulator,Element1) -> Accumulator)
  public init (apply: ((Accumulator,Element2) -> Accumulator) -> ((Accumulator,Element1) -> Accumulator))
  {
    self.apply = apply
  }
  
  /// compose/combine with another Transducer
  /// composition can be done naturally (contravariance is managed in the method itself)
  public func compose <Element3> (other: Transducer<Accumulator,Element2,Element3>) -> Transducer<Accumulator,Element1,Element3>
  {
    return Transducer<Accumulator,Element1,Element3> { reducer in self.apply(other.apply(reducer)) }
  }
}

/// quick way to define a custom transducer, considering the previous reducer and the new accumulator and element
public func customTransducer <Acc,E1,E2> (customChange: (((Acc,E2) -> Acc), Acc, E1) -> Acc) -> Transducer<Acc,E1,E2>
{
  return Transducer { reducer in
    return { accumulator, element in
      return customChange(reducer,accumulator,element)
    }
  }
}

/// unchanged reduce
public func emptyTransducer <Acc,E> () -> Transducer<Acc,E,E>
{
  return customTransducer { reducer, accumulator, element in
    return reducer(accumulator,element)
  }
}

/// lifts 'map' in the transducer world
public func mappingTransducer <Acc,E1,E2> (change: E1 -> E2) -> Transducer<Acc,E1,E2>
{
  return customTransducer { reducer, accumulator, element in
    return reducer(accumulator,change(element))
  }
}

/// lifts 'filter' in the transducer world
public func filteringTransducer <Acc,E> (filter: E -> Bool) -> Transducer<Acc,E,E>
{
  return customTransducer { reducer, accumulator, element in
    return filter(element) ? reducer(accumulator,element) : accumulator
  }
}


