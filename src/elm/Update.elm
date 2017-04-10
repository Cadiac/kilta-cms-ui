module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, NewsModel, NewsItem)

import RemoteData exposing (WebData)

setNewsList : WebData (List NewsItem) -> NewsModel -> NewsModel
setNewsList newsList news =
    { news | list = newsList }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Msgs.NoOp -> (model, Cmd.none)

    Msgs.Increment -> ({ model | amount = model.amount + 1 }, Cmd.none)

    Msgs.OnFetchSponsors response ->
      ( { model | sponsors = response }, Cmd.none )

    Msgs.OnFetchNews response ->
      ( { model | news = model.news
          |> setNewsList response
        }, Cmd.none )

    Msgs.OnFetchInfo response ->
      ( { model | info = response }, Cmd.none )
