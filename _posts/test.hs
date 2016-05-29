qsort :: [Int] -> [Int]

qsort [] = []

qsort (x : xs) =
    qsort smaller ++ [x] ++ bigger
    where
        smaller = [a | a <- xs, a <= x]
        bigger = [b | b <- xs, b > x]


repl :: Int -> a -> [a]

repl 0 x = []
repl n x =
    [x] ++ repl (n-1) x

