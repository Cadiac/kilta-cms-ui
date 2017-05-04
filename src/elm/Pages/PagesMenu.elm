module Pages.PagesMenu exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (PageItem, PageCategory, SubPage, Slug, Model)
import RemoteData exposing (WebData)

import Routing exposing (onLinkClick, pagePath, subPagePath)

pageItem : PageCategory -> Html Msg
pageItem page =
  div [] [
    p [ class "menu-label" ] [
      text page.title
    ],
    ul [ class "menu-list" ] (
      List.map (subPageItem page.slug) page.subpages
    )
  ]

subPageItem : Slug -> SubPage -> Html Msg
subPageItem category subPage =
  let
    url = subPagePath category subPage.slug
  in
    li [] [
      a [ href url, onLinkClick (Msgs.ChangeLocation url)] [
        text subPage.title
      ]
    ]

maybePagesList : WebData (List PageCategory) -> Html Msg
maybePagesList pages =
  case pages of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      aside [ class "menu" ] [
        p [ class "menu-label" ] [
          text "Loading..."
        ]
      ]

    RemoteData.Success pages ->
      aside [ class "menu" ] (
        List.map pageItem pages
      )

    RemoteData.Failure error ->
      text (toString error)


view : Model -> Html Msg
view model =
  maybePagesList model.pageCategories
