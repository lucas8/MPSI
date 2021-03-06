
-- Functions to analyze ------------------
pow :: Double -> Int -> Double
pow _ 0 = 1
pow 0 _ = 0
pow x n
     | n > 0 = x * pow x (n-1)
     | n < 0 = pow (1/x) (-n)

f :: Int -> Double -> Double -> Double
f n r x = (pow x n) - r
------------------------------------------

-- Secant method -------------------------
sec :: Double -> Double -> Double -> Double -> Double
sec x1 y1 x2 y2 = -y1 * (1/delta) + x1
    where delta = (y2 - y1)/(x2 - x1)

secant_cn :: (Double -> Double) -> Double -> Double -> Int -> Double -> (Double, Int)
secant_cn f a b n e
     | abs (f m) < e = (m,n)
     | n < maxN      = secant_cn f ma mb (n+1) e
     | otherwise     = (a ,n)           
    where m = sec a (f a) b (f b)
          ma = if f m > 0  then a else m
          mb = if f m <= 0 then b else m

secant :: (Double -> Double) -> Double -> Double -> Double -> Double
secant f a b e = m
    where (m,_) = secant_cn f a b 0 e
------------------------------------------

-- Dichotomy algorithm -------------------
root_cn :: (Double -> Double) -> Double -> Double -> Int -> Double -> (Double, Int)
root_cn f a b n e
     | (b-a) < e = (sec a (f a) b (f b), n)
     | n < maxN  = if (f a)*(f m) <= 0 then root_cn f a m (n+1) e else root_cn f m b (n+1) e
     | otherwise = (a,n)
    where m = (a+b)/2

root :: (Double -> Double) -> Double -> Double -> Double -> Double
root f a b e = m
    where (m,_) = root_cn f a b 0 e
------------------------------------------

-- Newton method -------------------------
delta :: (Double -> Double) -> Double -> Double
delta f x = ((f (x+h)) - (f (x-h))) / (2*h)
    where h = 1e-5

newton_cn :: (Double -> Double) -> (Double -> Double) -> Double -> Int -> Double -> (Double,Int)
newton_cn f df xn n e
     | xn - xn1 < e = (xn1,n)
     | n < maxN     = newton_cn f df xn1 (n+1) e
     | otherwise    = (xn,n)
    where xn1 = -(f xn)/(df xn) + xn

newton :: (Double -> Double) -> (Double -> Double) -> Double -> Double -> Double
newton f df xn e = m
    where (m,_) = newton_cn f df xn 0 e
------------------------------------------

-- Main ----------------------------------
epsilons = map (\x -> pow 10 (-x)) [0..]
prec = 10
p = 2 :: Int
x = 2 :: Double
maxN = 1000 :: Int

main = do putStrLn $ (++) "Precision : "   $ show $ epsilons !! prec
          putStrLn $ (++) "With secant : " $ show $ scs      !! prec
          putStrLn $ (++) "With dicho : "  $ show $ rts      !! prec
          putStrLn $ (++) "With newton : " $ show $ nts      !! prec
    where fn = (f p x)
          df = delta fn
          scs = map (secant_cn fn 0  x 0) epsilons
          rts = map (root_cn   fn 0  x 0) epsilons
          nts = map (newton_cn fn df x 0) epsilons
------------------------------------------

