module Arkham.Location.Cards.ArkhamWoodsTangledThicket (arkhamWoodsTangledThicket) where

import Arkham.GameValue
import Arkham.Location.Cards qualified as Cards
import Arkham.Location.Import.Lifted

newtype ArkhamWoodsTangledThicket = ArkhamWoodsTangledThicket LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

arkhamWoodsTangledThicket :: LocationCard ArkhamWoodsTangledThicket
arkhamWoodsTangledThicket =
  locationWith
    ArkhamWoodsTangledThicket
    Cards.arkhamWoodsTangledThicket
    2
    (PerPlayer 1)
    (investigateSkillL .~ #combat)

instance RunMessage ArkhamWoodsTangledThicket where
  runMessage msg (ArkhamWoodsTangledThicket attrs) =
    ArkhamWoodsTangledThicket <$> runMessage msg attrs
