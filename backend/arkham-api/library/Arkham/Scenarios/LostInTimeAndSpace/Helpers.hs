module Arkham.Scenarios.LostInTimeAndSpace.Helpers where

import Arkham.Campaigns.TheDunwichLegacy.Helpers
import Arkham.I18n
import Arkham.Prelude
import Arkham.Layout

scenarioI18n :: (HasI18n => a) -> a
scenarioI18n a = campaignI18n $ scope "lostInTimeAndSpace" a

scenarioLayout :: [GridTemplateRow]
scenarioLayout =
  [ ".              .                  .                  tearThroughSpace2 tearThroughSpace2    tearThroughSpace1    tearThroughSpace1    .                 .                 .                  ."
  , ".              .                  .                  tearThroughSpace2 tearThroughSpace2    tearThroughSpace1    tearThroughSpace1    .                 .                 .                  ."
  , ".              tearThroughSpace3  tearThroughSpace3  .                 .                    .                    .                    tearThroughSpace4 tearThroughSpace4 .                  ."
  , ".              tearThroughSpace3  tearThroughSpace3  .                 .                    .                    .                    tearThroughSpace4 tearThroughSpace4 .                  ."
  , "endlessBridge2 endlessBridge2     endlessBridge1     endlessBridge1    .                    unstableVortex       unstableVortex       prismaticCascade1 prismaticCascade1 toweringLuminosity toweringLuminosity"
  , "endlessBridge2 endlessBridge2     endlessBridge1     endlessBridge1    .                    unstableVortex       unstableVortex       prismaticCascade1 prismaticCascade1 toweringLuminosity toweringLuminosity"
  , ".              dimensionalDoorway dimensionalDoorway .                 anotherDimension     anotherDimension     .                    prismaticCascade2 prismaticCascade2 .                  ."
  , ".              dimensionalDoorway dimensionalDoorway .                 anotherDimension     anotherDimension     .                    prismaticCascade2 prismaticCascade2 .                  ."
  , ".              .                  realmsBeyond       realmsBeyond      tearThroughTime      tearThroughTime      indecipherableStairs stepsOfYhagharl   stepsOfYhagharl   .                  ."
  , ".              .                  realmsBeyond       realmsBeyond      tearThroughTime      tearThroughTime      indecipherableStairs stepsOfYhagharl   stepsOfYhagharl   .                  ."
  , ".              .                  .                  .                 theEdgeOfTheUniverse theEdgeOfTheUniverse .                    .                 .                 .                  ."
  , ".              .                  .                  .                 theEdgeOfTheUniverse theEdgeOfTheUniverse .                    .                 .                 .                  ."
  ]
