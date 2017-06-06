{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import           Data.Monoid ((<>))
import           Data.Aeson (FromJSON, ToJSON)
import           GHC.Generics
import           Web.Scotty

data User = User { userId :: Int, userName :: String } deriving (Show, Generic)
instance ToJSON User
instance FromJSON User

bob :: User
bob = User { userId = 1, userName = "bob" }

jenny :: User
jenny = User { userId = 2, userName = "jenny" }

allUsers :: [User]
allUsers = [bob, jenny]

matchesId :: Int -> User -> Bool
matchesId id user = userId user == id

main = do
  putStrLn "Starting server..."

  scotty 3000 $ do
    get "/" $ text "Welcome to awesome scotty!"

    get "/hello/:name/" $ do
      name <- param "name"
      text ("Hello " <> name <> "!")

    get "/users" $ json allUsers

    get "/users/:id" $ do
      id <- param "id"
      json (filter (matchesId id) allUsers)
