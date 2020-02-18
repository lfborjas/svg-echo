module Main exposing (DrawingState(..), Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type DrawingState
    = Done
    | Drawing


type Msg
    = Tapped


type alias Model =
    { startX : Maybe Int
    , startY : Maybe Int
    , endX : Maybe Int
    , endY : Maybe Int
    , drawingState : DrawingState
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { startX = Just 0
      , startY = Just 0
      , endX = Just 0
      , endY = Just 0
      , drawingState = Done
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    Debug.todo "TODO"


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


view : Model -> Document Msg
view model =
    { title = "SVG Echo"
    , body =
        [ div []
            [ svg []
                [ circle [ cx "200", cy "200", fill "red", r "20" ] [] ]
            ]
        ]
    }
