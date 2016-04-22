
public func appendReducer <A: RangeReplaceableCollectionType, E where E == A.Generator.Element> (var accumulator accumulator: A, element: E) -> A
{
  accumulator.append(element)
  return accumulator
}

public protocol Summable
{
  func + (lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension UInt: Summable {}
extension Float: Summable {}
extension Double: Summable {}

public func sumReducer <T: Summable> (accumulator accumulator: T, element: T) -> T
{
  return accumulator + element
}

