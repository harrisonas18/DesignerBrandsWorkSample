# Designer Brands Work Sample README
> An example command line program that solves the Designer Brands Work Sample Prompt.

## Explanation of Program

The program intakes a data file, in this instance a ".txt" file, via an argument in the form of an absolute path or just by specifying the file itself. You can also pipe a data file using standard input. See usage example below for more info on how to run the program.

Command line arguments are checked before standard input is read to determine how the program should run. An input data file is then parsed into structs which can be filtered and sorted based on the requirements at hand. Here I used a "ProductType" to hold the different parsed products and a "PriceType" to hold the different price categories. 

I separated logic into two functions. The first function called "parseContents" intakes a string which is the input data file and parses the contents into structs. To parse the contents, I first separated the string contents by new line "\n" into an array. Then broke down the individual line strings into another array using the "," separator. By now all of the data is ready to be made into structs which we can use to do operations on. All of the structs are added to a "PriceType" array or "ProductType" array.  

At the end of the "parseContents" function I call the "generateReport" function. This function intakes the "ProductType" array from "parseContents", then filters and sorts the products based on the price calculations constraints. Output data is formatted based on how many products fall under each category sorted in descending order, displaying the range of prices if applicable.

## Development Approach

In order to develop programs efficiently I first start by breaking down the task or problem into smaller subset problems. Here I started by identifying the data types that were specfied and made them into data structures. Then I thought about how I would import the data to be parsed, breaking down the imports into three different functions, one for each import method. 

After the data had been imported, I started thinking about how to sort and filter the data based on the constraints to prepare it for output. It made sense to breakdown the importing of data and the generation of the report into two separate functions, so I refactored the program to do that. 

Finally, after breaking down the data types and methods I thought about how the flow of the program would run. It becomes easier to see where methods should be called and data should be transformed when you think about the flow patterns of a program. From there I put everything together for each input method and handled errors accordingly, creating a final product.

## Trade Offs

I didn't really make use of the "PriceType" struct and it's data. Instead, I created an enum with hard coded values to reference a certain price type. PriceType was determined at initialization of the struct based on the problem constraints. The program could have been more modular if the price type rules were supplied in the data file.

Another trade off I implemented was the enforcement of the absolute path being in quotes. I had to remove the tilde character in the absolute path of the data file because of a bug zsh has when importing the absolute path without quotes.

## Bugs

Because of time constraints there are a few bugs which are not handled or which cause a hang up.

1. If no argument is passed for example

```sh
swift designerbrandsworksample.swift
```
then a hang up is caused. Use control + c to stop the program.

## Usage example

Executing with Absolute path. Absolute path passed must be in quotes to work. ZSH does not export absolute path argument correctly if it has a tilde "~" in it and it does not have quotes. Therefore in order to make sure the correct path is being passed we need to put it in quotes.

```sh
swift designerbrandsworksample.swift "~/user/{username}/{directory}/{filename}"
```

Executing by specifying a file. File passed can be in quotes or non quoted. Program searches current directory for file.

```sh
swift designerbrandsworksample.swift "data.txt"
```

Executing by piping data via standard input. 

```sh
cat data.txt | swift designerbrandsworksample.swift
```

## Testing Approach & Methodology

The testing methodology that I used falls somewhere between a waterfall style and incremental style. The program was developed step by step, adding, iterating, then testing to come up with a final product. 

Generally, I would try to get one input method working before moving onto the next combining them all in the end. Each function makes use of input verification to make sure we are catching incorrect formats and handling errors that weren't expected.

I tested 4 input methods for this project

1. Absolute path - passed
2. Specified File - passed
3. Piped Data - passed
4. No argument specified - failed

## Release History

* 0.0.1
    * Work Sample Solution 1



