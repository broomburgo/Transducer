
import XCTest
@testable import Transducer

class TransducerTests: XCTestCase
{
  let sumReducer: (Int, Int) -> Int = (+)

  func testTransducer()
  {
    let doublingTransducer = Transducer<Int,Int,Int> { reducer in
      return { accumulator, element in
        return reducer(accumulator,element*2)
      }
    }
    let sumDoubledReducer = doublingTransducer.apply(sumReducer)
    
    let array = [1,2,3,4,5]
    
    let sum = array.reduce(0, combine: sumReducer)
    XCTAssertEqual(sum, 15)
    
    let sumOfDoubled = array.reduce(0, combine: sumDoubledReducer)
    XCTAssertEqual(sumOfDoubled, 30)
  }
  
  func testEmptyTransducer()
  {
    let array = [1,2,3,4,5]
    let sameReducer = emptyTransducer().apply(sumReducer)
    let reduced1 = array.reduce(0, combine: sumReducer)
    let reduced2 = array.reduce(0, combine: sameReducer)
    XCTAssertNotEqual(reduced2, 0)
    XCTAssertEqual(reduced1, reduced2)
  }
  
  func testMappingTransducer()
  {
    let triplingTransducer: Transducer<Int,Int,Int> = mappingTransducer { $0*3 }
    let array = [1,2,3,4,5]
    let sumOfTripled = array.reduce(0, combine: triplingTransducer.apply(sumReducer))
    XCTAssertEqual(sumOfTripled, 45)
  }
  
  func testFilteringTransducer()
  {
    let evenTransducer: Transducer<Int,Int,Int> = filteringTransducer { $0%2 == 0 }
    let array = [1,2,3,4,5,6,7,8,9,10]
    let sumOfEvens = array.reduce(0, combine: evenTransducer.apply(sumReducer))
    XCTAssertEqual(sumOfEvens, 30)
  }
  
  func testCustomTransducer()
  {
    let weirdTransducer: Transducer<Int,Int,Int> = customTransducer { reducer, accumulator, element in
      return (element > 2 && element < 8) ? reducer(accumulator, element) : accumulator
    }
    let array = [1,2,3,4,5,6,7,8,9,10]
    let weirdSum = array.reduce(0, combine: weirdTransducer.apply(sumReducer))
    XCTAssertEqual(weirdSum, 25)
  }
  
  func testChainedTransducer()
  {
    let array = [1,2,3,4,5,6,7,8,9,10]
    let weirdSum1 = array.reduce(0, combine:
      emptyTransducer()
        .compose(mappingTransducer { $0*3+1 })
        .compose(filteringTransducer { $0%4 == 0 })
        .compose(mappingTransducer { $0-3 })
        .apply(sumReducer))
    XCTAssertEqual(weirdSum1, 39)
    let weirdSum2 = array.reduce(0, combine:
      emptyTransducer()
        .compose(filteringTransducer { $0%4 == 0 })
        .compose(mappingTransducer { $0*3+1 })
        .compose(mappingTransducer { $0-3 })
        .apply(sumReducer))
    XCTAssertEqual(weirdSum2, 32)
  }
}
