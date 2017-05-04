module Init exposing (..)

import Models exposing (..)
import Decoders exposing (maybeDecodeToken)

import Dict exposing (Dict)
import RemoteData exposing (WebData)

initialModel : Flags -> Route -> Model
initialModel flags route =
  { info = RemoteData.NotAsked
  , footer = RemoteData.NotAsked
  , news = Dict.empty
  , newsList = RemoteData.NotAsked
  , events = Dict.empty
  , eventsList = RemoteData.NotAsked
  , newsCategories = RemoteData.NotAsked
  , pageCategories = RemoteData.NotAsked
  , pages = Dict.empty
  , sponsors = RemoteData.NotAsked
  , amount = 0
  , config = flags
  , route = route
  , token = flags.token
  , decodedToken = maybeDecodeToken flags.token
  , profile = RemoteData.NotAsked
  , username = ""
  , password = ""
  , error = ""
  }
