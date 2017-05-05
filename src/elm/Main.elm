module Main exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, Flags, Info, Image)
import Init exposing (initialModel)
import Update exposing (update)
import View exposing (view)

import Time exposing (Time, second)

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
  if model.logoutTimer > 0 then
    Sub.batch [
      Time.every second Msgs.LogoutTimerTick,
      Time.every (10 * second) Msgs.ChangeJumbotronImage
    ]
  else
    Time.every (10 * second) Msgs.ChangeJumbotronImage

-- APP


main : Program Flags Model Msg
main =
  Navigation.programWithFlags Msgs.OnLocationChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
