module Lib
  ( someFunc
  , possibleCourses
  , Course(..)
  , Requirements(..)
  ) where

import qualified Data.HashSet as HashSet
import Types

someFunc :: IO ()
someFunc = putStrLn "someFunc"


canTakeCourse :: HashSet.HashSet String -> Course -> Bool
canTakeCourse _ (Course {name = _, preReqs = []}) = True
canTakeCourse coursesTaken course =
  foldr
    (\preReq canTake -> (&&) canTake $ HashSet.member preReq coursesTaken)
    True $
  preReqs course

possibleCourses :: [Course] -> HashSet.HashSet String -> [Course]
possibleCourses coursesRequired coursesTaken =
  filter (\course -> not $ HashSet.member (name course) coursesTaken) $
  filter (canTakeCourse coursesTaken) coursesRequired
