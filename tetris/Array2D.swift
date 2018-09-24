// This helper file will help access grid coordinates in your code.
// If you know the column and row numbers of a specific item, you can
// index the array as follows: myCookie = cookies[column, row]
// The notation Array2D<T> means that this struct is a generic and can
// hold elements of any type T

class Array2D {
    let columns: Int
    let rows: Int
    var array: Array<Int>
    
    init(columns: Int, rows: Int, initialNumber: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<Int>(repeating: initialNumber, count: rows * columns)
    }

    convenience init(columns: Int, rows: Int) {
        self.init(columns: columns, rows: rows, initialNumber: 0)
    }
    
    subscript(column: Int, row: Int) -> Int {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }

    func clear(with initialNumber: Int = 0) {
        array = Array<Int>(repeating: initialNumber, count: rows * columns)
    }
}
