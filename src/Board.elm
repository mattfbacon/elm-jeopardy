module Board exposing (Board, BoardMsg(..), CurrentDialogMsg(..), CurrentItem, ItemState(..), CurrentItemState(..), setState, complete, isCompleted, isDailyDouble, new, viewBoard, viewCurrent)

import Array as A exposing (Array)
import Config as C
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Position exposing (Position(..))


type ItemState
    = IncompleteItem
    | CompletedItem


type alias Board =
    Array (Array ItemState)


type CurrentItemState
    = Active
    | ShowAnswer


type alias CurrentItem =
    { pos : Position
    , state : CurrentItemState
    }


type BoardMsg
    = Click Position


get2D : Int -> Int -> Array (Array a) -> Maybe a
get2D row col =
    (A.get col |> Maybe.andThen) << A.get row



-- currentAnswer : Position -> Maybe CurrentItem -> Maybe CurrentItemState
-- currentAnswer pos =
--     Maybe.andThen
--         (\current ->
--             if current.pos == pos then
--                 Just current.state
--             else
--                 Nothing
--         )


itemSpecificClasses : ItemState -> List (H.Attribute msg)
itemSpecificClasses item =
    case item of
        CompletedItem ->
            [ HA.class "completed" ]

        IncompleteItem ->
            []


viewItem : Int -> Int -> ItemState -> Html BoardMsg
viewItem row col item =
    H.div
        (List.append
            [ HA.class "item" ]
            (itemSpecificClasses item)
        )
        [ H.span [ HA.class "value" ] <| List.singleton <| H.text <| ("$" ++ (String.fromInt <| rowValue row))
        ]


rowValue : Int -> Int
rowValue row_num =
    (row_num + 1) * 200


makeTable : List (H.Attribute BoardMsg) -> Array (Html BoardMsg) -> Array (Array (Html BoardMsg)) -> Html BoardMsg
makeTable attrs headings rows =
    H.table
        attrs
        [ H.thead [] [ H.tr [] <| A.toList <| A.map (H.th [] << List.singleton) headings ]
        , H.tbody [] <| A.toList <| A.indexedMap (\row_num -> H.tr [] << A.toList << A.indexedMap (\col_num -> H.td [HE.onClick <| Click <| Position row_num col_num] << List.singleton)) rows
        ]


viewBoard : Board -> Html BoardMsg
viewBoard board =
    makeTable [ HA.id "board", HA.attribute "style" <| "--col-num: " ++ (String.fromInt <| Maybe.withDefault 0 <| Maybe.map A.length <| A.get 0 board) ++ ";" ] (A.map (H.text << String.toUpper) C.headers) <| A.indexedMap (viewItem >> A.indexedMap) board


new : Board
new =
    A.repeat C.rows (A.repeat C.cols IncompleteItem)


setState : ItemState -> Position -> Board -> Board
setState newState (Position row col) board =
    case A.get row board of
        Nothing ->
            board

        Just rowData ->
            A.set row (A.set col newState rowData) board


complete : Position -> Board -> Board
complete =
    setState CompletedItem


isDailyDouble : Position -> Bool
isDailyDouble (Position row col) =
    case get2D row col C.items of
        Nothing ->
            False

        Just item ->
            item.dailyDouble


isCompleted : Position -> Board -> Bool
isCompleted (Position row col) board =
    Maybe.withDefault False <| Maybe.map ((==) CompletedItem) <| get2D row col board


type CurrentDialogMsg
    = DialogClick


currentActive : Maybe a -> List (H.Attribute msg)
currentActive x =
    case x of
        Nothing ->
            []

        Just _ ->
            [ HA.class "active" ]


viewCurrent : Maybe CurrentItem -> Html CurrentDialogMsg
viewCurrent current_ =
    H.aside (List.append [ HA.id "currentdialog", HE.onClick DialogClick ] <| currentActive current_)
        [ H.text <|
            Maybe.withDefault "" <|
                Maybe.map
                    (case Maybe.withDefault Active <| Maybe.map .state current_ of
                        Active ->
                            .question

                        ShowAnswer ->
                            .answer
                    )
                <|
                    Maybe.andThen
                        (\current ->
                            let
                                (Position row col) =
                                    current.pos
                            in
                            get2D row col C.items
                        )
                        current_
        ]
