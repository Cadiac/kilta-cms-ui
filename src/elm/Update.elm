module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)
import Navigation exposing (newUrl)
import Commands exposing (submitCredentials)

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
      model ! [ submitCredentials model ]

    Msgs.Auth res ->
      case res of
        Result.Ok token ->
            ( { model | token = Just token }, Cmd.none )

        Result.Err err ->
            ( { model | error = toString err }, Cmd.none )

    Msgs.FormInput inputId val ->
      case inputId of
        Models.Username ->
          { model | username = val } ! []

        Models.Password ->
          { model | password = val } ! []

    Msgs.OnFetchSponsors response ->
      ( { model | sponsors = response }, Cmd.none )

    Msgs.OnFetchNewsList response ->
      ( { model | newsList = response }, Cmd.none )

    Msgs.OnFetchSingleNewsStory newsId response ->
      ( { model | news = Dict.insert newsId (response) model.news }, Cmd.none )

    Msgs.OnFetchInfo response ->
      ( { model | info = response }, Cmd.none )
