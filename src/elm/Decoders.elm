module Decoders exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, requiredAt)

import Models exposing (..)

sponsorsDecoder : Decoder (List Sponsor)
sponsorsDecoder =
  list sponsorDecoder

sponsorDecoder : Decoder Sponsor
sponsorDecoder =
  decode Sponsor
    |> required "name" string
    |> required "website" string
    |> requiredAt ["logo", "url"] string

infoDecoder : Decoder Info
infoDecoder =
  decode Info
    |> required "main_title" string
    |> required "introduction_text" string
    |> required "guild_name" string
    |> required "guild_logo" imageDecoder
    |> required "jumbotron_images" (list jumbotronDecoder)

imageDecoder : Decoder Image
imageDecoder =
  decode Image
    |> required "url" string
    |> required "thumbnail" string

jumbotronDecoder : Decoder JumbotronImage
jumbotronDecoder =
  decode JumbotronImage
    |> required "title" string
    |> required "url" string

newsDecoder : Decoder (List NewsItem)
newsDecoder =
  list newsItemDecoder

newsItemDecoder : Decoder NewsItem
newsItemDecoder =
  decode NewsItem
    |> required "id" int
    |> required "title" string
    |> required "text" string
    |> required "slug" string
    |> required "created_on" string
    |> required "tags" string
    |> required "news_category" int
    |> required "authors" (list string)

tokenStringDecoder : Decoder String
tokenStringDecoder =
  field "token" string

tokenDecoder : Decoder JwtToken
tokenDecoder =
  decode JwtToken
    |> required "id" int
    |> required "role" string
    |> required "username" string
    |> required "iat" int
    |> required "exp" int