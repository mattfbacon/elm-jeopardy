module MsgModel exposing (Model, Msg(..), boardMsgToOurs, dialogMsgToOurs)

import Board exposing (Board, CurrentItem)
import Position exposing (Position)


type Msg
    = Click Position
    | ExitCurrent
    | CompleteCurrent
    | ToggleAnswer
    | NullMessage


type alias Model =
    { board : Board
    , current : Maybe CurrentItem
    }


boardMsgToOurs : Board.BoardMsg -> Msg
boardMsgToOurs msg =
    case msg of
        Board.Click pos ->
            Click pos


dialogMsgToOurs : Board.CurrentDialogMsg -> Msg
dialogMsgToOurs msg =
    case msg of
        Board.DialogClick ->
            CompleteCurrent
