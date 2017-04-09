module Commands exposing (..)

import Http

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Msgs exposing (Msg)
import Models exposing (Flags, Info, Image, JumbotronImage, Sponsor, NewsItem)
import RemoteData

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

fetchNews : String -> Cmd Msg
fetchNews apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/news"
  in
    Http.get url newsDecoder
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnFetchNews

-- DECODERS


sponsorsDecoder : Decode.Decoder (List Sponsor)
sponsorsDecoder =
  Decode.list sponsorDecoder

sponsorDecoder : Decode.Decoder Sponsor
sponsorDecoder =
  decode Sponsor
    |> required "name" Decode.string
    |> required "website" Decode.string
    |> requiredAt ["logo", "url"] Decode.string

infoDecoder : Decode.Decoder Info
infoDecoder =
  decode Info
    |> required "main_title" Decode.string
    |> required "introduction_text" Decode.string
    |> required "guild_name" Decode.string
    |> required "guild_logo" imageDecoder
    |> required "jumbotron_images" (Decode.list jumbotronDecoder)

imageDecoder : Decode.Decoder Image
imageDecoder =
  decode Image
    |> required "url" Decode.string
    |> required "thumbnail" Decode.string

jumbotronDecoder : Decode.Decoder JumbotronImage
jumbotronDecoder =
  decode JumbotronImage
    |> required "title" Decode.string
    |> required "url" Decode.string

newsDecoder : Decode.Decoder (List NewsItem)
newsDecoder =
  Decode.list newsItemDecoder

newsItemDecoder : Decode.Decoder NewsItem
newsItemDecoder =
  decode NewsItem
    |> required "id" Decode.int
    |> required "title" Decode.string
    |> required "text" Decode.string
    |> required "slug" Decode.string
    |> required "created_on" Decode.string
    |> required "tags" Decode.string
    |> required "news_category" Decode.int
    |> required "authors" (Decode.list Decode.string)
