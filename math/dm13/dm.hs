type Corps = Double
type Poly = [Corps]

zeros :: Int -> [Corps]
zeros n = fmap (\x -> 0) [1..n]

deg :: Poly -> Int
deg p = length p

dom :: Poly -> Corps
dom p = p!!(deg p - 1)

norm :: Poly -> Poly
norm [l] = [l]
norm l   = normalize 0 l
    where normalize :: Int -> Poly -> Poly
          normalize _ []     = []
          normalize n (0:ls) = normalize (n+1) ls
          normalize n (l:ls) = zeros n ++ [l] ++ normalize 0 ls

multXp :: Poly -> Int -> Corps -> Poly
multXp [] _ _ = []
multXp pl p l = zeros p ++ fmap (*l) pl

addP :: Poly -> Poly -> Poly
addP []     b      = b
addP a      []     = a
addP (a:as) (b:bs) = (a+b) : addP as bs

divEuclid :: Poly -> Poly -> (Poly,Poly)
divEuclid a b = mdiv [] a b
    where mdiv :: Poly -> Poly -> Poly -> (Poly,Poly)
          mdiv q a b = if deg a < deg b then (q, a)
                       else mdiv q2 r b
              where d  = deg a - deg b
                    c  = dom a / dom b
                    r  = hd $ addP a $ multXp b d (-1*c)
                    q2 = c:q
                    hd (a:as) = if length as == 0 then [] else a:hd as

compXp :: Int -> Poly -> Poly
compXp n p = norm $ (p!!0):[value i | i <- [1..(n*deg p - 1)]]
    where value i = if i `mod` n == 0 then (p!!(div i n)) else 0

first :: (a, b) -> a
first (x, _) = x

pow :: Int -> Int -> Int
pow _ 0 = 1
pow x n = x * pow x (n-1)

polyCyclo :: [(Int,Int)] -> Poly
polyCyclo []          = [-1, 1]
polyCyclo ((p,a):cfs) = first $ divEuclid (compXp cf pl) pl
    where cf = p * foldl (*) 1 [pow pl (al - 1) | (pl,al) <- (p,a):cfs]
          pl = polyCyclo cfs

nsqrt :: Int -> Int
nsqrt n = truncate $ sqrt $ fromRational $ toRational n

merge :: [(Int,Int)] -> [(Int,Int)] -> [(Int,Int)]
merge a []         = a
merge a ((p,e):ls) = merge a2 ls
    where a2 = if find p a then fmap apply a else (p,e):a
            where find _ []     = False
                  find f ((l,_):ls) = if f == l then True else find f ls
                  apply (p2,e2) = if p2 == p then (p2, e+e2) else (p2,e2)

decomp :: Int -> [(Int,Int)]
decomp 1 = []
decomp n = if length dvs == 0 then [(n,1)] 
           else let (d,d2) = ((dvs!!0), n `div` d) in merge (decomp d) (decomp d2)
    where dvs = [d | d <- [2..nsqrt n], n `mod` d == 0]

polyCyclo2 :: Int -> Poly
polyCyclo2 n = polyCyclo $ decomp n

main :: IO()
main = putStrLn $ show $ polyCyclo2 60

