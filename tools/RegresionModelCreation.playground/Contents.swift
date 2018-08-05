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
    
    let url = URL(fileURLWithPath: "Users/juangabriel/Developer/Projects/Xcode/Cursos/ios-12/tools/house_pricing_data.json")
    
    print(url)
    
    let data = try MLDataTable(contentsOf: url)
    
    /*Users/juangabriel/Developer/Projects/Xcode/Cursos/ios-12/tools/house_pricing_data.json -- file:///
     Parsing JSON records from /Users/juangabriel/Developer/Projects/Xcode/Cursos/ios-12/tools/house_pricing_data.json
     Successfully parsed an SArray of 100000 elements from the JSON file /Users/juangabriel/Developer/Projects/Xcode/Cursos/ios-12/tools/house_pricing_data.json
     */
    
    let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 2018)
    
    if(false){
        let modelPricer = try MLRegressor(trainingData: trainingData, targetColumn: "value")
        
        var metrics = modelPricer.evaluation(on: testingData)
        
        print("RMSE: \(metrics.rootMeanSquaredError)") //34767€
        
        print("Max Error: \(metrics.maximumError)") //199014€
    }
    // (2+3+4)/3 = 3
    // (3+3+3)/3 = 3
    // sqrt((2^2+3^2+4^2)/3) ~ 3.1
    // sqrt((3^2+3^2+3^2)/3) ~ 3
    
    /*Using 6 features to train a model to predict value.
     
     Automatically generating validation set from 5% of the data.
     Boosted trees regression:
     --------------------------------------------------------
     Number of examples          : 75677
     Number of features          : 6
     Number of unpacked features : 6
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     | Iteration | Elapsed Time | Training max_error | Validation max_error | Training rmse | Validation rmse |
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     | 1         | 0.031495     | 1708329.250000     | 1568901.125000       | 427434.937500 | 422246.343750   |
     | 2         | 0.060345     | 1283788.750000     | 1144360.750000       | 302204.718750 | 298712.250000   |
     | 3         | 0.091550     | 972999.625000      | 873408.875000        | 214843.828125 | 212672.343750   |
     | 4         | 0.122685     | 722541.875000      | 622951.125000        | 153742.906250 | 152224.468750   |
     | 5         | 0.152746     | 572032.875000      | 472442.125000        | 111190.632812 | 110209.125000   |
     | 10        | 0.301312     | 212657.250000      | 173279.375000        | 33919.535156  | 34598.660156    |
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     RMSE: 34767.29920163662
     Max Error: 199014.375*/
    
    
    //RANDOM FOREST
    if(false){
        let paramsForest = MLRandomForestRegressor.ModelParameters(maxIterations: 500)
        
        let modelForest = try MLRandomForestRegressor(trainingData: trainingData, targetColumn: "value", parameters: paramsForest)
        
        let metrics = modelForest.evaluation(on: testingData)
        
        print("RMSE: \(metrics.rootMeanSquaredError)") //60329€
        
        print("Max Error: \(metrics.maximumError)") //503351€
    }
    /*Using 6 features to train a model to predict value.
     
     Automatically generating validation set from 5% of the data.
     Random forest regression:
     --------------------------------------------------------
     Number of examples          : 75677
     Number of features          : 6
     Number of unpacked features : 6
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     | Iteration | Elapsed Time | Training max_error | Validation max_error | Training rmse | Validation rmse |
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     | 1         | 0.030598     | 521178.375000      | 484178.375000        | 84291.445312  | 87648.101562    |
     | 2         | 0.057295     | 473903.000000      | 404803.000000        | 83754.601562  | 86807.007812    |
     | 3         | 0.086790     | 470372.750000      | 365372.750000        | 68573.679688  | 70398.054688    |
     | 4         | 0.115064     | 469413.125000      | 364413.125000        | 64074.308594  | 65174.164062    |
     | 5         | 0.145007     | 504785.125000      | 399785.125000        | 60672.593750  | 61645.324219    |
     | 10        | 0.290110     | 459955.000000      | 405955.000000        | 64865.386719  | 65112.781250    |
     | 50        | 1.436804     | 502714.125000      | 454688.000000        | 57938.843750  | 57091.945312    |
     | 100       | 2.901237     | 536450.875000      | 469284.875000        | 62543.902344  | 61400.027344    |
     | 250       | 7.280026     | 526500.000000      | 460728.750000        | 60384.320312  | 59227.824219    |
     | 500       | 14.389489    | 524044.500000      | 459766.250000        | 59135.429688  | 58006.097656    |
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     RMSE: 60329.457070629185
     Max Error: 503351.875*/
    
    
    //BOOSTED TREE
    let paramsBoosted = MLBoostedTreeRegressor.ModelParameters(maxIterations: 500)
    
    let modelBoosted = try MLBoostedTreeRegressor(trainingData: trainingData, targetColumn: "value", parameters: paramsBoosted)
    
    let metrics = modelBoosted.evaluation(on: testingData)
    
    print("RMSE: \(metrics.rootMeanSquaredError)") //23963€
    
    print("Max Error: \(metrics.maximumError)") //109263€
    
     /*Using 6 features to train a model to predict value.
     
     Automatically generating validation set from 5% of the data.
     Boosted trees regression:
     --------------------------------------------------------
     Number of examples          : 75677
     Number of features          : 6
     Number of unpacked features : 6
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     | Iteration | Elapsed Time | Training max_error | Validation max_error | Training rmse | Validation rmse |
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     | 1         | 0.037315     | 1708329.250000     | 1568901.125000       | 427434.937500 | 422246.343750   |
     | 2         | 0.065656     | 1283788.750000     | 1144360.750000       | 302204.718750 | 298712.250000   |
     | 3         | 0.095123     | 972999.625000      | 873408.875000        | 214843.828125 | 212672.343750   |
     | 4         | 0.122448     | 722541.875000      | 622951.125000        | 153742.906250 | 152224.468750   |
     | 5         | 0.149619     | 572032.875000      | 472442.125000        | 111190.632812 | 110209.125000   |
     | 10        | 0.291354     | 212657.250000      | 173279.375000        | 33919.535156  | 34598.660156    |
     | 50        | 1.351959     | 112120.750000      | 87760.687500         | 23265.359375  | 24542.642578    |
     | 100       | 2.723606     | 92782.750000       | 82868.875000         | 22217.435547  | 24150.658203    |
     | 250       | 6.804568     | 82566.687500       | 78951.875000         | 20740.349609  | 23963.123047    |
     | 500       | 13.632607    | 80480.625000       | 82014.937500         | 19205.109375  | 24251.125000    |
     +-----------+--------------+--------------------+----------------------+---------------+-----------------+
     RMSE: 23963.08097880136
     Max Error: 109263.125*/
    
    
    let metadata = MLModelMetadata(author: "Juan Gabriel Gomila",
                                   shortDescription: "Modelo de entrenamiento para predecir el precio de venta de una casa con Boosted.",
                                   license: "CC0",
                                   version: "1.0")
    
    try modelBoosted.write(to: URL(fileURLWithPath: "Users/juangabriel/Developer/Projects/Xcode/Cursos/ios-12/tools/HousePriceModel.mlmodel"), metadata: metadata)
    
    
} else {
    // Fallback on earlier versions
}
