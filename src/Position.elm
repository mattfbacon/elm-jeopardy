module Position exposing (Position(..), mapX, mapY, x, y)


type Position
    = Position Int Int


x : Position -> Int
x (Position px _) =
    px


y : Position -> Int
y (Position _ py) =
    py


mapX : (Int -> Int) -> Position -> Position
mapX fn (Position px py) =
    Position (fn px) py


mapY : (Int -> Int) -> Position -> Position
mapY fn (Position px py) =
    Position px (fn py)
