module Pages.PagesMenu exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (PageItem, PageCategory, SubPage, Slug, Route, Model)
import RemoteData exposing (WebData)

import Routing exposing (..)

subMenuItem : Slug -> Route -> SubPage -> Html Msg
subMenuItem category currentRoute subPage =
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

categoryItem : Route -> PageCategory -> List (Html Msg)
categoryItem currentRoute pageCategory =
  [
    p [ class "menu-label" ] [
      text pageCategory.title
    ],
    ul [ class "menu-list" ] (
      List.map (subMenuItem pageCategory.slug currentRoute) pageCategory.subpages
    )
  ]


maybeMenuItems : WebData (List PageCategory) -> Route -> List (Html Msg)
maybeMenuItems pages currentRoute =
  case pages of
    RemoteData.NotAsked ->
      [ text "" ]

    RemoteData.Loading ->
      [ text "Loading..." ]

    RemoteData.Success pages ->
      List.concat (List.map (categoryItem currentRoute) pages)

    RemoteData.Failure error ->
      [ text (toString error) ]

sideMenu : WebData (List PageCategory) -> WebData (List PageCategory) -> Route -> Html Msg
sideMenu pages boards currentRoute =
  aside [ class "menu" ] (
    List.concat [
      maybeMenuItems pages currentRoute,
      maybeMenuItems boards currentRoute
    ]
  )

view : Model -> Html Msg
view model =
  sideMenu model.pageCategories model.boardsList model.route
