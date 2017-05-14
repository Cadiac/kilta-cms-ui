module Pages.BoardPage exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Dict exposing (Dict)
import Models exposing (BoardItem, Model, Slug)

import Pages.PagesMenu

import Markdown

boardItem : BoardItem -> Html Msg
boardItem board =
  article [] [
    div [ class "heading" ] [
      h2 [ class "subtitle is-4" ] [
        text board.meta.title
      ]
    ]
    , Markdown.toHtml [ class "content" ] board.meta.text
  ]

maybePageContent : WebData (BoardItem) -> Html Msg
maybePageContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success board ->
      boardItem board

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Slug -> Html Msg
view model year =
  section [ class "section" ] [
    div [ class "columns" ] [
      div [ class "column is-3" ] [
        Pages.PagesMenu.view model
      ],
      div [ class "column" ] [
        maybePageContent (
          Dict.get year model.boards
            |> Maybe.withDefault RemoteData.NotAsked
        )
      ]
    ]
  ]
