public class fileMaker{
    public init(){
        
    }
    public func makeFile(val1:String){
        let fileName = "flutter_swift"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
        print("FilePath: \(fileURL.path)")
                
//        var writeString = val1+","
        var writeString = val1
        do {
            // Write to the file
            let oldContent = try String(contentsOf:fileURL, encoding: .utf8)
            writeString = oldContent + writeString
            try writeString.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
     
        var readString = "" // Used to store the file contents
        do {
            // Read the file contents
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        print("File Text: \(readString)")
    }
    
    public func makeFile_blank(val1:String){
        let fileName = "flutter_swift"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
        print("FilePath: \(fileURL.path)")
                
        var writeString = val1
        do {
            // Write to the file
            try writeString.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
     
        var readString = "" // Used to store the file contents
        do {
            // Read the file contents
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        print("File Text: \(readString)")
    }
}
