module Pages.SubPage exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Dict exposing (Dict)
import Models exposing (PageItem, Model, Slug)

import Pages.PagesMenu

import Markdown

pageItem : PageItem -> Html Msg
pageItem subpage =
  article [] [
    div [ class "heading" ] [
      h2 [ class "subtitle is-4" ] [
        text subpage.title
      ]
    ]
    , Markdown.toHtml [ class "content" ] subpage.text
  ]

maybePageContent : WebData (PageItem) -> Html Msg
maybePageContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success page ->
      pageItem page

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Slug -> Html Msg
view model slug =
  section [ class "section" ] [
    div [ class "columns" ] [
      div [ class "column is-3" ] [
        Pages.PagesMenu.view model
      ],
      div [ class "column" ] [
        maybePageContent (
          Dict.get slug model.pages
            |> Maybe.withDefault RemoteData.NotAsked
        )
      ]
    ]
  ]
