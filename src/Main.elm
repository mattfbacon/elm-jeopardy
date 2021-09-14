port module Main exposing (main)

import Board exposing (viewBoard, viewCurrent)
import Browser as B exposing (Document)
import Browser.Events as BE
import Config as C
import Html as H exposing (Html)
import Html.Attributes as HA
import Json.Decode as Decode
import MsgModel exposing (Model, Msg)
import Position exposing (Position(..))


main : Program () Model Msg
main =
    B.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { board = Board.new
      , current = Nothing
      }
    , Cmd.none
    )


body : Model -> List (Html Msg)
body model =
    [ H.h1 [ HA.id "title" ] <| [ H.text <| C.name ++ " Jeopardy" ]
    , H.map MsgModel.boardMsgToOurs <| viewBoard model.board
    , H.map MsgModel.dialogMsgToOurs <| viewCurrent model.current
    ]


view : Model -> Document Msg
view model =
    { title = C.name ++ " Jeopardy"
    , body = body model
    }


type
    UpdateCurrentResult
    -- isomorphic with Maybe Board.CurrentItem; used for clarity
    = Updated Board.CurrentItem
    | DailyDouble Board.CurrentItem
    | Completed


updateCurrent : Position -> Maybe Board.CurrentItem -> UpdateCurrentResult
updateCurrent pos current_ =
    case current_ of
        Nothing ->
            (if Board.isDailyDouble pos then
                DailyDouble

             else
                Updated
            )
                { pos = pos, state = Board.Active }

        Just current ->
            if current.pos == pos then
                case current.state of
                    Board.Active ->
                        Updated { current | state = Board.ShowAnswer }

                    Board.ShowAnswer ->
                        Completed

            else
                (if Board.isDailyDouble pos then
                    DailyDouble

                 else
                    Updated
                )
                    { pos = pos, state = Board.Active }


port makeAlert : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgModel.Click pos ->
            if Board.isCompleted pos model.board then
                ( { model | board = Board.setState Board.IncompleteItem pos model.board}, Cmd.none )

            else
                case updateCurrent pos model.current of
                    Updated newCurrent ->
                        ( { model | current = Just newCurrent }, Cmd.none )

                    DailyDouble newCurrent ->
                        ( { model | current = Just newCurrent }, makeAlert "Daily double!" )

                    Completed ->
                        ( { model | current = Nothing, board = Board.complete pos model.board }, Cmd.none )

        MsgModel.ExitCurrent ->
            ( { model | current = Nothing }, Cmd.none )

        MsgModel.CompleteCurrent ->
            case model.current of
                Nothing ->
                    ( model, Cmd.none )

                Just current ->
                    ( { model | current = Nothing, board = Board.complete current.pos model.board }, Cmd.none )

        MsgModel.ToggleAnswer ->
            ( { model
                | current =
                    Maybe.map
                        (\x ->
                            { x
                                | state =
                                    case x.state of
                                        Board.ShowAnswer ->
                                            Board.Active

                                        Board.Active ->
                                            Board.ShowAnswer
                            }
                        )
                        model.current
              }
            , Cmd.none
            )

        MsgModel.NullMessage ->
            ( model, Cmd.none )


keyDecoder : Decode.Decoder MsgModel.Msg
keyDecoder =
    Decode.map
        (\str ->
            case str of
                "a" ->
                    MsgModel.ToggleAnswer

                "Enter" ->
                    MsgModel.CompleteCurrent

                "Escape" ->
                    MsgModel.ExitCurrent

                "Esc" ->
                    MsgModel.ExitCurrent

                _ ->
                    MsgModel.NullMessage
        )
    <|
        Decode.field "key" Decode.string


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.current of
        Nothing ->
            Sub.none

        Just _ ->
            BE.onKeyUp keyDecoder
