module Pages.PagesList exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (PageItem, PageCategory, SubPage, Slug, Model)
import RemoteData exposing (WebData)

import Routing exposing (onLinkClick, pagePath, subPagePath)

navItem : String -> String -> Html Msg
navItem url title =
  div [ class "nav-item" ] [
    a [ href url, onLinkClick (Msgs.ChangeLocation url)] [
      h1 [ class "heading" ] [
        text title
      ]
    ]
  ]

pageItem : PageCategory -> Html Msg
pageItem page =
  div [] [
    navItem (pagePath page.slug) page.title,
    div [] (
      List.map (subPageItem page.slug) page.subpages
    )
  ]

subPageItem : Slug -> SubPage -> Html Msg
subPageItem category subPage =
  navItem (subPagePath category subPage.slug) subPage.title

maybePagesList : WebData (List PageCategory) -> Html Msg
maybePagesList pages =
  case pages of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      navItem "/" "Loading..."

    RemoteData.Success pages ->
      div [] (
        List.map pageItem pages
      )

    RemoteData.Failure error ->
      text (toString error)


view : Model -> Html Msg
view model =
  section [ class "box" ] [
    maybePagesList model.pageCategories
  ]
