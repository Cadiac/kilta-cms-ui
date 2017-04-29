module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)
import Navigation exposing (newUrl)

import Commands exposing (fetchSingleNewsStory)

import Dict exposing (Dict)

import Routing exposing (parseLocation)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Msgs.NoOp -> (model, Cmd.none)

    Msgs.Increment -> ({ model | amount = model.amount + 1 }, Cmd.none)

    Msgs.ChangeLocation path ->
      ( model, newUrl path )

    Msgs.OnLocationChange location ->
      let
        newRoute =
          parseLocation location
      in
        case newRoute of
          Models.IndexRoute ->
            ( { model | route = newRoute }, Cmd.none )
          Models.NewsListRoute ->
            ( { model | route = newRoute }, Cmd.none )
          Models.NewsRoute newsId ->
            let
              alreadyFetched =
                Dict.member newsId model.news
            in
              if alreadyFetched then
                ( { model | route = newRoute }, Cmd.none )
              else
                ( { model | route = newRoute }
                , (fetchSingleNewsStory model.config.apiUrl newsId)
                )
          Models.NotFoundRoute ->
            ( { model | route = newRoute }, Cmd.none )


    Msgs.OnFetchSponsors response ->
      ( { model | sponsors = response }, Cmd.none )

    Msgs.OnFetchNewsList response ->
      ( { model | newsList = response }, Cmd.none )

    Msgs.OnFetchSingleNewsStory newsId response ->
      ( { model | news = Dict.insert newsId (response) model.news }, Cmd.none )

    Msgs.OnFetchInfo response ->
      ( { model | info = response }, Cmd.none )
