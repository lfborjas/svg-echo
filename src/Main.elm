module Main exposing (DrawingState(..), Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (on)
import Json.Decode as Json exposing (Decoder, field, int, map2)
import Svg exposing (..)
import Svg.Attributes exposing (..)


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


type alias Position =
    { x : Int
    , y : Int
    }


type Msg
    = Tapped Position


type alias Model =
    { start : Maybe Position
    , end : Maybe Position
    , drawingState : DrawingState
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { start = Just <| Position 0 0
      , end = Just <| Position 0 0
      , drawingState = Done
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tapped pos ->
            Debug.log (Debug.toString pos) <|
                ( { model | start = Just pos }, Cmd.none )


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


view : Model -> Document Msg
view model =
    { title = "SVG Echo"
    , body =
        [ div [ onClickLocation model ]
            [ svg []
                [ circle [ cx "200", cy "200", fill "red", r "20" ] [] ]
            ]
        ]
    }


onClickLocation : Model -> Html.Attribute Msg
onClickLocation model =
    on "click" <| Json.map Tapped <| positionDecoder


positionDecoder : Decoder Position
positionDecoder =
    map2 Position
        (field "pageX" int)
        (field "pageY" int)
