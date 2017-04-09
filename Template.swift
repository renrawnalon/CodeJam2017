import Foundation

func solve(aCase: String) -> String {
    return aCase
}


// Boilerplate

enum GeneralError: Error {
    case badNews
}

func main() {
    let args = CommandLine.arguments
    let testCase = args[0].components(separatedBy: ".")[0]
    let inputSize = args[1]
    let path = FileManager.default.currentDirectoryPath + "/" + testCase + "-" + inputSize
    let url = URL(fileURLWithPath: path + ".in")
    guard let content = fileContents(url: url) else {
        print("Could not read contents of file at path: \(url)")
        return 
    }
    let input = Array(content.components(separatedBy: "\n").dropFirst().dropLast())

    solve(input: input).writeToFile(path: URL(fileURLWithPath: path + ".out"))
}

func solve(input: [String]) -> String {
    let solutions = input.map { solve(aCase: $0 ) }

    var array: [String] = []
    for (i, solution) in solutions.enumerated() {
        array = array + ["Case #\(i + 1): " + solution]
    }
    return array.joined(separator: "\n").appending("\n")
}

func fileContents(url: URL) -> String? {
    do {
        return try String(contentsOf: url)
    } catch {
        return nil
    }
}

extension String {
    func writeToFile(path: URL) {
        do {
            try write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print("Couldn't write to file at path: \(path)")
        }
    }
}

extension Int {
    func minusOne() -> Int {
        return self == 0 ? 9 : self - 1
    }
}

main()
