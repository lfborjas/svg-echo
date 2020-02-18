module Main exposing (DrawingState(..), Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes
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
    ( { start = Nothing
      , end = Nothing
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
            case model.drawingState of
                Done ->
                    ( { model | start = Just pos, drawingState = Drawing, end = Nothing }, Cmd.none )

                Drawing ->
                    ( { model | end = Just pos, drawingState = Done }, Cmd.none )


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


view : Model -> Document Msg
view model =
    { title = "SVG Echo"
    , body =
        [ div [ Html.Attributes.id "container", onClickLocation model ]
            [ svg []
                [ drawStart model
                , drawEnd model
                ]
            ]
        ]
    }


drawStart : Model -> Svg Msg
drawStart { start } =
    case start of
        Nothing ->
            g [] []

        Just pos ->
            drawMarker "Start: " "red" pos


drawEnd : Model -> Svg Msg
drawEnd { end } =
    case end of
        Nothing ->
            g [] []

        Just pos ->
            drawMarker "End: " "blue" pos


drawMarker : String -> String -> Position -> Svg Msg
drawMarker label fillColor pos =
    let
        px =
            String.fromInt <| pos.x

        py =
            String.fromInt <| pos.y

        offsetX =
            String.fromInt <| pos.x - 40

        offsetY =
            String.fromInt <| pos.y + 30
    in
    g []
        [ circle [ cx px, cy py, fill fillColor, r "20" ] []
        , text_ [ x px, y offsetY, Svg.Attributes.style ("font: sans-serif; fill: " ++ fillColor ++ ";") ]
            [ Svg.text <| label ++ px ++ ", " ++ py ]
        ]



-- from: https://stackoverflow.com/questions/40269494/elm-adding-click-events-to-svg-elements-doesnt-work-is-this-possible


onClickLocation : Model -> Html.Attribute Msg
onClickLocation model =
    on "click" <| Json.map Tapped <| positionDecoder


positionDecoder : Decoder Position
positionDecoder =
    map2 Position
        (field "pageX" int)
        (field "pageY" int)
