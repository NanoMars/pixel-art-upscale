import Data.List (transpose)

type Pixels = [[Int]]

loadPixels :: IO Pixels
loadPixels = do
    contents <- readFile "source.txt"
    return $ map (map read . words) $ lines contents

scanRow :: Int -> Pixels -> Int
scanRow size pixels =
    if (length pixels) < size
        then 0
        else 
            let
                row1:row2:_ = pixels
                row = zip row1 row2
                rest = drop size pixels
            in
                sum [abs (a-b) | (a,b) <- row] + scanRow size rest


testScan :: Int -> Int -> Int -> Pixels -> Int -> Int -> Float
testScan offsetX offsetY size pixels width height =
    let
        row = scanRow size $ drop offsetY pixels
        col = scanRow size $ drop offsetX (transpose pixels)
    in
        ((fromIntegral row) / fromIntegral (height `div` size) )+ ((fromIntegral col) / fromIntegral (width `div` size))

findBestOffsetX :: Int -> Pixels -> Int -> Int -> Int -> Int -> (Int, Float)
findBestOffsetX     _      _        _       _      _      (-1) = (0, -1)
findBestOffsetX    size   pixels   width  height offsetY maxOffsetX =
    let
        this = testScan maxOffsetX offsetY size pixels width height
        next@(_,another) = findBestOffsetX size pixels width height offsetY (maxOffsetX-1)
    in
        if this > another
            then (maxOffsetX, this)
            else next

findBestOffset :: Int -> Pixels -> Int -> Int -> Int  -> (Int, Int, Float)
findBestOffset    _       _        _       _     (-1) =  (-1, -1, -1)
findBestOffset   size    pixels   width   height  maxOffsetY = 
    let 
        (x,this) = findBestOffsetX size pixels width height maxOffsetY (size-1)
        next@(_,_,another) = findBestOffset size pixels width height (maxOffsetY-1)
    in
        if this>another
            then (x, maxOffsetY,this)
            else next

findBestSize :: Pixels -> Int -> Int -> Int -> (Int, Int, Int, Float)
findBestSize     _         _      _      3 = (0, 0, 0, -1)
findBestSize     pixels   width  height  maxSize =
    let
        (x,y,this) = findBestOffset maxSize pixels width height (maxSize-1) 
        next@(_,_,_,another) = findBestSize pixels width height (maxSize-1)
    in
        if this<another
            then (maxSize, x,y,this)
            else next

main = do
    pixels <- loadPixels
    let height = length pixels
    let width = length $ head pixels
    let (size,offsetX,offsetY,_)=findBestSize pixels width height 3 --(min width height `div` 30)
    putStrLn $ show size
    putStrLn $ show offsetX
    putStrLn $ show offsetY