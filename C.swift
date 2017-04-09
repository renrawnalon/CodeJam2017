import Foundation

struct Pair: Equatable, Comparable {
    let value: Int
    let count: Int

    init(value: Int, count: Int) {
        self.value = max(value, 0)
        self.count = count
    }

    static func ==(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.value == rhs.value
    }

    static func <(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.value < rhs.value
    }
}

func solve(aCase: String) -> String {
    let stallCount = Int(aCase.components(separatedBy: " ")[0])!
    let peopsCount = Int(aCase.components(separatedBy: " ")[1])!
    var array = [Pair(value: stallCount, count: 1)]

    var remainingCount = peopsCount
    while remainingCount > 0 {
        let maxPair = array.max()!
        let maxIndex = array.index(of: maxPair)!

        if maxPair.count < remainingCount {
            let pairs = bisect(pair: maxPair, remainingCount: remainingCount)
            array.remove(at: maxIndex)
            array += pairs
            remainingCount -= maxPair.count
        } else {
            break
        }

        array = merge(pairs: array)
    }

    let maxPair = array.max()!
    let pairs = bisect(pair: maxPair, remainingCount: remainingCount)

    if pairs.count == 2 {
        return "\(pairs[1].value) \(pairs[0].value)"
    } else {
        return "\(pairs[0].value) \(pairs[0].value)"
    }
}

func bisect(pair: Pair, remainingCount: Int) -> [Pair] {
    if pair.value % 2 == 0 {
        return [Pair(value: pair.value / 2 - 1, count: pair.count), Pair(value: pair.value / 2, count: pair.count)]
    } else {
        return [Pair(value: (pair.value - 1) / 2, count: pair.count * 2)]
    }
}

func merge(pairs: [Pair]) -> [Pair] {
    var newPairs = [Pair]()
    for pair in pairs {
        if let index = newPairs.index(where: { $0 == pair }) {
            let oldPair = newPairs[index]
            newPairs.remove(at: index)
            newPairs += [Pair(value: oldPair.value, count: oldPair.count + pair.count)]
        } else {
            newPairs += [pair]
        }
    }
    return newPairs
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

