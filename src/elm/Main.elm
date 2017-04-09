module Main exposing (..)

import Html exposing (program)

import Msgs exposing (Msg)
import Models exposing (initialModel, Model, Flags, Info, Image)
import Update exposing (update)
import View exposing (view)
import Api exposing (getSponsors)

-- INIT

init : Flags -> (Model, Cmd Msg)
init flags =
  ( initialModel flags
  , getSponsors flags.apiUrl
  )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- APP


main : Program Flags Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
