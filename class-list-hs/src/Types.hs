{-# LANGUAGE DeriveGeneric #-}
module Types (
    Course(..)
    , Requirements(..)
) where

import GHC.Generics
import Data.Hashable
import Data.Aeson

data Requirements =
    Requirements
        { requiredCourses :: [Course]
        , coursesTaken :: [String]
        }
    deriving (Generic)

data Course =
  Course
    { name :: String
    , preReqs :: [String]
    }
  deriving (Eq, Show, Generic)

instance Hashable Course where
  hashWithSalt salt course = hashWithSalt salt $ name course
  hash course = hash $ name course

instance ToJSON Requirements
instance FromJSON Requirements
instance ToJSON Course
instance FromJSON Course
