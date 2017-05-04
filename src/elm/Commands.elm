port module Commands exposing (..)

import Http

import Jwt exposing (..)

import Msgs exposing (Msg)
import Models exposing (..)
import RemoteData

import Decoders exposing (..)
import Json.Encode as Encode exposing (Value)


-- PORTS

port saveToken : String -> Cmd msg
port clearToken : () -> Cmd msg
port setTitle : String -> Cmd msg

-- COMMANDS


fetchSponsors : String -> Cmd Msg
fetchSponsors apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/sponsors"
  in
    Http.get url sponsorsDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchSponsors

fetchInfo : String -> Cmd Msg
fetchInfo apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/info"
  in
    Http.get url infoDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchInfo

fetchFooter : String -> Cmd Msg
fetchFooter apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/footer"
  in
    Http.get url footerDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchFooter

fetchNewsList : String -> Cmd Msg
fetchNewsList apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/news"
  in
    Http.get url newsDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchNewsList

fetchSingleNewsStory : String -> NewsId -> Cmd Msg
fetchSingleNewsStory apiUrl newsId =
  let
    url =
      apiUrl ++ "/api/v1/news/" ++ toString newsId
  in
    Http.get url newsItemDecoder
      |> RemoteData.sendRequest
      |> Cmd.map (Msgs.OnFetchSingleNewsStory newsId)

fetchEventsList : String -> Cmd Msg
fetchEventsList apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/events"
  in
    Http.get url eventsDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchEventsList

fetchSingleEvent : String -> EventId -> Cmd Msg
fetchSingleEvent apiUrl eventId =
  let
    url =
      apiUrl ++ "/api/v1/events/" ++ toString eventId
  in
    Http.get url eventItemDecoder
      |> RemoteData.sendRequest
      |> Cmd.map (Msgs.OnFetchSingleEvent eventId)


submitCredentials : Model -> Cmd Msg
submitCredentials model =
  let
    authUrl =
      model.config.apiUrl ++ "/api/v1/auth/login"
  in
    Encode.object
      [ ( "username", Encode.string model.username )
      , ( "password", Encode.string model.password )
      ]
      |> authenticate authUrl tokenStringDecoder
      |> Http.send Msgs.Auth

fetchProfile : String -> String -> Cmd Msg
fetchProfile apiUrl token =
  let
    url =
      apiUrl ++ "/api/v1/members/me"
  in
    Jwt.get token url profileDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchProfile

fetchNewsCategories : String -> Cmd Msg
fetchNewsCategories apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/news/categories"
  in
    Http.get url newsCategoriesDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchNewsCategories

fetchPageCategories : String -> Cmd Msg
fetchPageCategories apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/pages"
  in
    Http.get url pageCategoriesDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchPageCategories

fetchSinglePage : String -> Slug -> Cmd Msg
fetchSinglePage apiUrl slug =
  let
    url =
      apiUrl ++ "/api/v1/pages/" ++ slug
  in
    Http.get url pageDecoder
      |> RemoteData.sendRequest
      |> Cmd.map (Msgs.OnFetchSinglePage slug)
