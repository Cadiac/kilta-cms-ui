module Api exposing (..)

import Msgs exposing (Msg)
import Models exposing (Flags, Info, Image, JumbotronImage)

import Http
import Json.Decode exposing (Decoder, string, list, map2, map3, map5, at)

import Components.Sponsors exposing ( Sponsor )

getSponsors : String -> Cmd Msg
getSponsors apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/sponsors"

    request =
      Http.get url decodeSponsors
  in
    Http.send Msgs.FetchSponsors request

decodeSponsors : Decoder (List Sponsor)
decodeSponsors =
  Json.Decode.list (map3 Sponsor
    (at ["name"] string)
    (at ["website"] string)
    (at ["logo", "url"] string)
  )

getInfo : String -> Cmd Msg
getInfo apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/info"

    request =
      Http.get url decodeInfo
  in
    Http.send Msgs.FetchInfo request

decodeInfo : Decoder (Info)
decodeInfo =
  map5 Info
    (at ["main_title"] string)
    (at ["introduction_text"] string)
    (at ["guild_name"] string)
    (at ["guild_logo"] (map2 Image
      (at ["url"] string)
      (at ["thumbnail"] string)
    ))
    (at ["jumbotron_images"]
      (Json.Decode.list (map2 JumbotronImage
        (at ["title"] string)
        (at ["url"] string)
      ))
    )
