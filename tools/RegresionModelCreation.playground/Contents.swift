import CreateML
import Foundation

/*
let input = [2,4,6]
//................
//... Core ML  ...
//................
let output = [6, 12, 18]

let newInput = 10
let newOutput = 20


func calculateValue(for input: Int) -> Int{
    if input < 10 {
        return input * 3
    } else {
        return input * 2
    }
}
*/

// ...........
// MLRegressor
// ...........
/*
 - Modelos de regresión lineal
 applyLinReg(var1, var2, var3) -> a0 + a1*var1 + a2*var2 + a3*var3 + var1*var2/var3
 
 MLLinearRegressor
 */
/*
 - Árboles de decisión para regresión

 MLDecisionTreeRegressor

*/

/*
 - Boosted trees
 
 MLBoostedTreeRegressor

 */

/*
 - Random Forests
 
 MLRandomForestRegressor
*/

if #available(OSX 10.14, *) {
    
    let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "housing-pricing-data.json"))
    
    let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 2018)
    
    let modelPricer = try MLRegressor(trainingData: trainingData, targetColumn: "value")
    
    var metrics = modelPricer.evaluation(on: testingData)
    
    print("RMSE: \(metrics.rootMeanSquaredError)") //20.764€
    
    print("Max Error: \(metrics.maximumError)") //126.876€
    
    // (2+3+4)/3 = 3
    // (3+3+3)/3 = 3
    // sqrt((2^2+3^2+4^2)/3) ~ 3.1
    // sqrt((3^2+3^2+3^2)/3) ~ 3
    
    
    //RANDOM FOREST
    let paramsForest = MLRandomForestRegressor.ModelParameters(maxIterations: 500)
    
    let modelForest = try MLRandomForestRegressor(trainingData: trainingData, targetColumn: "value", parameters: paramsForest)
    
    metrics = modelForest.evaluation(on: testingData)
    
    print("RMSE: \(metrics.rootMeanSquaredError)") //40.764€
    
    print("Max Error: \(metrics.maximumError)") //126.876€
    
    
    //BOOSTED TREE
    let paramsBoosted = MLBoostedTreeRegressor.ModelParameters(maxIterations: 500)
    
    let modelBoosted = try MLBoostedTreeRegressor(trainingData: trainingData, targetColumn: "value", parameters: paramsBoosted)
    
    metrics = modelBoosted.evaluation(on: testingData)
    
    print("RMSE: \(metrics.rootMeanSquaredError)") //2.764€
    
    print("Max Error: \(metrics.maximumError)") //126.876€
    
    
    let metadata = MLModelMetadata(author: "Juan Gabriel Gomila",
                                   shortDescription: "Modelo de entrenamiento para predecir el precio de venta de una casa.",
                                   license: "CC0",
                                   version: "1.0")
    
    try modelPricer.write(to: URL(fileURLWithPath: "HousePriceModel.mlmodel"), metadata: metadata)
    
    
} else {
    // Fallback on earlier versions
}
