module Arkham.Event.Events.UncageTheSoul (uncageTheSoul) where

import Arkham.Cost
import Arkham.Effect.Runner
import Arkham.Event.Cards qualified as Cards
import Arkham.Event.Import.Lifted
import Arkham.Helpers.Cost (getSpendableResources)
import Arkham.Helpers.Playable (getIsPlayableWithResources)
import Arkham.Matcher hiding (PlayCard)
import Arkham.Window (defaultWindows)

newtype UncageTheSoul = UncageTheSoul EventAttrs
  deriving anyclass (IsEvent, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

uncageTheSoul :: EventCard UncageTheSoul
uncageTheSoul = event UncageTheSoul Cards.uncageTheSoul

instance RunMessage UncageTheSoul where
  runMessage msg e@(UncageTheSoul attrs) = runQueueT $ case msg of
    PlayThisEvent iid (is attrs -> True) -> do
      let windows'' = nub $ attrs.windows <> defaultWindows iid
      availableResources <- getSpendableResources iid
      cards <-
        filterM
          (getIsPlayableWithResources iid GameSource (availableResources + 3) (UnpaidCost NoAction) windows'')
          =<< select (inHandOf NotForPlay iid <> basic (oneOf [#spell, #ritual]))

      focusCards cards do
        chooseTargetM iid cards \card -> do
          unfocusCards
          reduceCostOf attrs card 3
          playCardPayingCost iid card

      pure e
    _ -> UncageTheSoul <$> liftRunMessage msg attrs
