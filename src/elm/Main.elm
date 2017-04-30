module Main exposing (..)

import Msgs exposing (Msg)
import Models exposing (initialModel, Model, Flags, Info, Image)
import Update exposing (update)
import View exposing (view)

import Navigation exposing ( Location )
import Routing

-- INIT

init : Flags -> Location -> (Model, Cmd Msg)
init flags location =
  let
    currentRoute =
      Routing.parseLocation location
    initial =
      initialModel flags currentRoute
  in
    ( initial
    , Routing.fetchLocationData currentRoute initial
    )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- APP


main : Program Flags Model Msg
main =
  Navigation.programWithFlags Msgs.OnLocationChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
