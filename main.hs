import Data.List (transpose)

type Pixels = [[Int]]
type Cache = ([Int],[Int])

loadPixels :: IO Pixels
loadPixels = do
    contents <- readFile "source.txt"
    return $ map (map read . words) $ lines contents

scanRow :: Pixels -> [Int]
scanRow    [_] = []
scanRow (row1:row2:rest) =
    let
        row = zip row1 row2
    in
        (sum [abs (a-b) | (a,b) <- row] ):scanRow (row2:rest)



testScan :: Int -> Int -> Int -> Cache -> Int -> Int -> IO Float
testScan offsetX offsetY size cache width height= do
    let row = sum [(fst cache) !! y | y <- [offsetY..height-1] , (y-offsetY) `mod` size == 0]
    let col = sum [(snd cache) !! x | x <- [offsetX..width-1] , (x-offsetX) `mod` size == 0]
    let result = ((fromIntegral row) / fromIntegral (height `div` size) ) + ((fromIntegral col) / fromIntegral (width `div` size))
    putStrLn $ "size:" ++ show size ++ "\tox: " ++ show offsetX ++ "\toy: " ++ show offsetY ++ "\tresult:" ++ show result
    return result

findBestOffsetX :: Int -> Cache -> Int -> Int -> Int -> Int -> IO (Int, Float)
findBestOffsetX     _      _        _       _      _      (-1) = return (0, -1)
findBestOffsetX    size   cache   width  height offsetY maxOffsetX =do
    this <- testScan maxOffsetX offsetY size cache width height
    next@(_,another) <- findBestOffsetX size cache width height offsetY (maxOffsetX-1)
    if this > another
        then return (maxOffsetX, this)
        else return next

findBestOffset :: Int -> Cache -> Int -> Int -> Int  -> IO (Int, Int, Float)
findBestOffset    _       _        _       _     (-1) =  return (-1, -1, -1)
findBestOffset   size    cache   width   height  maxOffsetY = do
    (x,this) <- findBestOffsetX size cache width height maxOffsetY (size-1)
    next@(_,_,another) <- findBestOffset size cache width height (maxOffsetY-1)
    if this > another
        then return (x, maxOffsetY,this)
        else return next

findBestSize :: Cache -> Int -> Int -> Int -> IO (Int, Int, Int, Float)
findBestSize     _         _      _      3 = return (0, 0, 0, -1)
findBestSize     cache   width  height  maxSize = do
    (x,y,this) <- findBestOffset maxSize cache width height (maxSize-1) 
    next@(_,_,_,another) <- findBestSize cache width height (maxSize-1)
    if this > another
        then return (maxSize, x,y,this)
        else return next

main = do
    pixels <- loadPixels
    let height = length pixels
    let width = length $ head pixels
    let cache = (scanRow pixels, scanRow $ transpose pixels)
    (size,offsetX,offsetY,_) <- findBestSize cache width height 30 --(min width height `div` 30)
    putStrLn $ show size
    putStrLn $ show offsetX
    putStrLn $ show offsetY