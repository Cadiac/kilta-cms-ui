module Pages.PagesMenu exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (PageItem, PageCategory, SubPage, Slug, Route, Model)
import RemoteData exposing (WebData)

import Routing exposing (..)

categoryItem : Route -> PageCategory -> List (Html Msg)
categoryItem currentRoute pageCategory =
  [
    p [ class "menu-label" ] [
      text pageCategory.title
    ],
    ul [ class "menu-list" ] (
      List.map (subPageItem pageCategory.slug currentRoute) pageCategory.subpages
    )
  ]

subPageItem : Slug -> Route -> SubPage -> Html Msg
subPageItem category currentRoute subPage =
  let
    url =
      subPagePath category subPage.slug

    urlLocation =
      urlToLocation url

    active =
      isActivePage urlLocation currentRoute
  in
    if active then
      a [ class "is-active", href url, onLinkClick (Msgs.ChangeLocation url)] [
        text subPage.title
      ]
    else
      li [] [
        a [ href url, onLinkClick (Msgs.ChangeLocation url)] [
          text subPage.title
        ]
      ]

maybePagesList : WebData (List PageCategory) -> Route -> Html Msg
maybePagesList pages currentRoute =
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
        List.concat (List.map (categoryItem currentRoute) pages)
      )

    RemoteData.Failure error ->
      text (toString error)


view : Model -> Html Msg
view model =
  maybePagesList model.pageCategories model.route
