import CreateMLUI

if #available(OSX 10.14, *) {
    let builder = MLImageClassifierBuilder()
    builder.showInLiveView()

} else {
    // Fallback on earlier versions
}
