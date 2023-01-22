module RandomNumberGenerator exposing (main)

import Browser
import Html exposing (Html, button, div, h1, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
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

randomNumberGenerator : Int -> Int -> Random.Generator Int
randomNumberGenerator min max =
    Random.int min max

view : Model -> Html Msg
view model =
    div []
    [ h1 [] [ text "Random Number Generator" ]
    , label [] [ text "min." ]
    , input [ type_ "number", value (String.fromInt model.min) ] []
    , label [] [ text "max." ]
    , input [ type_ "number", value (String.fromInt model.max) ] []
    , button [ onClick (GenerateRandomNumber model.min model.max) ] [ text "Generate" ]
    , label [] [ text (String.fromInt model.randomNumber) ]
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateRandomNumber min max ->
            ( model, Random.generate GotRandomNumber (randomNumberGenerator min max) )
        GotRandomNumber randomNumber ->
            ( { model | randomNumber = randomNumber }, Cmd.none )

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
