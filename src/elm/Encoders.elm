module Encoders exposing (..)

import Json.Encode as Encode exposing (..)

import Models exposing (..)

profileEncoder : Maybe Profile -> Encode.Value
profileEncoder profile =
  case profile of
    Just profile ->
      Encode.object
        [ ("first_name", Encode.string profile.firstName)
        , ("last_name", Encode.string profile.lastName)
        , ("email", Encode.string profile.email)
        , ("phone", Encode.string profile.phone)
        ]
    Nothing ->
      Encode.object []
