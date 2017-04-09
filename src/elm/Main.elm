module Main exposing (..)

import Html exposing (program)

import Msgs exposing (Msg)
import Models exposing (Model)
import Update exposing (update)
import View exposing (view)
import Types exposing (Flags, Info, Image)
import Api exposing (getSponsors)

-- INIT

init : Flags -> (Model, Cmd Msg)
init flags =
  ( Model
      (Info "" "" "" (Image "" "") [])
      []
      0
      flags
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
