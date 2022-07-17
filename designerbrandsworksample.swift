
import Foundation

enum ProductPriceType: String, CaseIterable {
    case NormalPrice = "Normal Price"
    case ClearancePrice = "Clearance Price"
    case PriceInCart = "Price In Cart"
}

struct PriceType {
    var delimiter = "Type"
    var idKey = ""
    var displayName = ""
}

struct ProductType {
    var delimiter = "Product"
    var normalPrice = 0.0
    var clearancePrice = 0.0
    var quantityInStock = 0
    var priceIsHidden = false
    var productPriceType: ProductPriceType
    
    init(delimiter: String, normalPrice: Double, clearancePrice: Double, quantityInStock: Int, priceIsHidden: Bool) {
        //Calculate productPriceType at initialization so we can
        if priceIsHidden {
            self.productPriceType = ProductPriceType.PriceInCart
        } else if normalPrice > clearancePrice {
            self.productPriceType = ProductPriceType.ClearancePrice
        } else {
            self.productPriceType = ProductPriceType.NormalPrice
        }
        
        self.delimiter = delimiter
        self.normalPrice = normalPrice
        self.clearancePrice = clearancePrice
        self.quantityInStock = quantityInStock
        self.priceIsHidden = priceIsHidden
        
    }
    
}

struct Output {
    var productPriceType: ProductPriceType
    var numberOfProductsInCategory = 0
    var priceRange: [Double]
}


if CommandLine.arguments.count < 2 {
    
    let standardInput = FileHandle.standardInput
    let input = standardInput.availableData
    let string = String(decoding: input, as: UTF8.self)
    if string.isEmpty || string == " "{
        print("No data to process. Please try again.")
        exit(0)
    } else {
        parseContents(contents: string)
    }
} else {
    var argumentString = CommandLine.arguments[1]
    if argumentString.first == "~" {
        argumentString.removeFirst()
        if let fileContent = try? String(contentsOfFile: argumentString) {
            parseContents(contents: fileContent)
        }
    } else if argumentString.contains(".txt") {
        do {
            let currentDirectory = FileManager.default.currentDirectoryPath
            let filePath = "\(currentDirectory)/\(argumentString)"
            let string = try? String(contentsOfFile: filePath)
            parseContents(contents: string ?? "")
        }
    }  else {
        //Error check string to make sure it satisfies our constraints 1. if not a path 2. if not a pipe 3. if not a specified file 4. must be an incorrect reading of string return error incorrect format
        print("Error invalid input, please try again.")
        exit(0)
    }
}

func parseContents(contents: String) {
    
    var types: [PriceType] = [] //Array to hold price type objects once they are parsed
    var products: [ProductType] = [] //Array to hold product objects once they are parsed
    
    //Separating input lines with the \n newline character delimiter - we can assume that every new line of input will contain a new Type object.
    let contentArray = contents.components(separatedBy: "\n")
    
    //if the content array is empty then we don't have contents so we return
    if contentArray[0] == "" {
        print("No data to process. Please try again.")
        exit(0)
    }
    
    for subArray in contentArray {
        let parsedSubArray = subArray.components(separatedBy: ",")
        if parsedSubArray[0] == "Type" {
            let newType = PriceType(delimiter: "Type", idKey: parsedSubArray[1], displayName: parsedSubArray[2])
            types.append(newType)
        } else {
            let newProductType = ProductType(delimiter: "Product Type", normalPrice: Double(parsedSubArray[1])!, clearancePrice: Double(parsedSubArray[2])!, quantityInStock: Int(parsedSubArray[3])!, priceIsHidden: Bool(parsedSubArray[4])!)
            products.append(newProductType)
        }
    }
    
    //After we have parsed our input data we generate a report that will display the filtered and sorted Product Objects
    generateReport(products: products)

}

func generateReport(products: [ProductType]){
    let filteredProducts = products.filter { $0.quantityInStock > 3 }
    var outputArray: [Output] = []
    for type in ProductPriceType.allCases {
        let sortedProducts = filteredProducts.filter {$0.productPriceType == type}.sorted { $0.clearancePrice < $1.clearancePrice}
        let outputPriceType = Output(productPriceType: type, numberOfProductsInCategory: sortedProducts.count, priceRange: [sortedProducts.first?.clearancePrice ?? 0, sortedProducts.last?.clearancePrice ?? 0])
        outputArray.append(outputPriceType)
    }

    let outputSorted = outputArray.sorted {$0.numberOfProductsInCategory > $1.numberOfProductsInCategory}
    
    for item in outputSorted {
            //format output here
            if item.priceRange[0] == 0 && item.priceRange[1] == 0 {
                print("\(item.productPriceType.rawValue): \(item.numberOfProductsInCategory) products")
            } else if item.priceRange[0] == item.priceRange[1] {
                print("\(item.productPriceType.rawValue): \(item.numberOfProductsInCategory) products @ $\(item.priceRange[0])")
            } else {
                print("\(item.productPriceType.rawValue): \(item.numberOfProductsInCategory) products @ $\(item.priceRange[0])-$\(item.priceRange[1])")
            }
    }
    exit(0)
}


