module Commands exposing (..)

import Http

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Msgs exposing (Msg)
import Models exposing (Flags, Info, Image, JumbotronImage, Sponsor)
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
