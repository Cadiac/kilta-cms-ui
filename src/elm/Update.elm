module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)
import Navigation exposing (newUrl)
import Commands exposing (submitCredentials, saveToken, clearToken)
import Decoders exposing (maybeDecodeToken)

import Dict exposing (Dict)

import Routing exposing (parseLocation, fetchLocationData)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Msgs.NoOp -> (model, Cmd.none)

    Msgs.ChangeLocation path ->
      ( model, newUrl path )

    Msgs.OnLocationChange location ->
      let
        newRoute =
          parseLocation location
        command =
          fetchLocationData newRoute model
      in
        ( { model | route = newRoute }, command )

    Msgs.Login ->
      model !
        [ submitCredentials model
        , newUrl "/"
        ]

    Msgs.Logout ->
      { model | token = "", decodedToken = Nothing } !
        [ clearToken ()
        , newUrl "/"
        ]

    Msgs.Auth res ->
      case res of
        Result.Ok tokenString ->
          ( { model | token = tokenString, decodedToken = maybeDecodeToken tokenString }, saveToken tokenString )

        Result.Err err ->
          ( { model | token = "", decodedToken = Nothing, error = toString err }, Cmd.none )

    Msgs.LoginFormInput inputId val ->
      case inputId of
        Models.Username ->
          { model | username = val } ! []

        Models.Password ->
          { model | password = val } ! []

    Msgs.ProfileFormInput inputId val ->
      case inputId of
        Models.FirstName ->
          { model | username = val } ! []

        Models.LastName ->
          { model | username = val } ! []

        Models.Email ->
          { model | username = val } ! []

        Models.Phone ->
          { model | username = val } ! []

    Msgs.OnFetchSponsors response ->
      ( { model | sponsors = response }, Cmd.none )

    Msgs.OnFetchProfile response ->
      ( { model | profile = response}, Cmd.none )

    Msgs.OnFetchNewsList response ->
      ( { model | newsList = response }, Cmd.none )

    Msgs.OnFetchSingleNewsStory newsId response ->
      ( { model | news = Dict.insert newsId (response) model.news }, Cmd.none )

    Msgs.OnFetchInfo response ->
      ( { model | info = response }, Cmd.none )
