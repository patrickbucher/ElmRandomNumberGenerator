module RandomNumberGenerator exposing (main)

import Browser
import Html exposing (Html, button, div, h1, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Random
-- elm install elm/random

type alias Model =
    { min : Int
    , max : Int
    , randomNumber : Int
    }

type Msg
    = GenerateRandomNumber Int Int
    | GotRandomNumber Int
    | ChangeMin String
    | ChangeMax String

randomNumberGenerator : Int -> Int -> Random.Generator Int
randomNumberGenerator min max =
    Random.int min max

view : Model -> Html Msg
view model =
    div []
    [ h1 [] [ text "Random Number Generator" ]
    , label [] [ text "min." ]
    , input [ type_ "number", value (String.fromInt model.min), onInput ChangeMin ] []
    , label [] [ text "max." ]
    , input [ type_ "number", value (String.fromInt model.max), onInput ChangeMax ] []
    , button [ onClick (GenerateRandomNumber model.min model.max) ] [ text "Generate" ]
    , label [] [ text (String.fromInt model.randomNumber) ]
    ]

parseInt : String -> Int -> Int
parseInt str default =
    case String.toInt str of
        Just val ->
            val
        Nothing ->
            default

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateRandomNumber min max ->
            ( model, Random.generate GotRandomNumber (randomNumberGenerator min max) )
        GotRandomNumber randomNumber ->
            ( { model | randomNumber = randomNumber }, Cmd.none )
        ChangeMin input ->
            ( { model | min = parseInt input initialModel.min }, Cmd.none )
        ChangeMax input ->
            ( { model | max = parseInt input initialModel.max }, Cmd.none )

initialModel : Model
initialModel =
    { min = 1
    , max = 100
    , randomNumber = 0
    }

main : Program () Model Msg
main =
    Browser.element
    { init = \flags -> ( initialModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \model -> Sub.none
    }
