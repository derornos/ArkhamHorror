module Arkham.Location.Cards.DeconstructionRoom (deconstructionRoom) where

import Arkham.Ability
import Arkham.GameValue
import Arkham.Location.Cards qualified as Cards
import Arkham.Location.Runner
import Arkham.Prelude
import Arkham.ScenarioLogKey

newtype DeconstructionRoom = DeconstructionRoom LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

deconstructionRoom :: LocationCard DeconstructionRoom
deconstructionRoom =
  location DeconstructionRoom Cards.deconstructionRoom 3 (PerPlayer 1)

-- Test combat (4) to attempt to retrieve a valuable organ from one of the alien
-- cadavers. This test gets +1 difficulty for each clue on Deconstruction Room.
-- If you succeed, remember that you "dissected an organ."

instance HasAbilities DeconstructionRoom where
  getAbilities (DeconstructionRoom attrs) =
    withBaseAbilities
      attrs
      [skillTestAbility $ restricted attrs 1 Here $ ActionAbility [] $ ActionCost 1]

instance RunMessage DeconstructionRoom where
  runMessage msg l@(DeconstructionRoom attrs) = case msg of
    UseCardAbility iid (isSource attrs -> True) 1 _ _ -> do
      sid <- getRandom
      push
        $ beginSkillTest
          sid
          iid
          (attrs.ability 1)
          iid
          #combat
          (SumCalculation [Fixed 4, LocationFieldCalculation attrs.id LocationClues])
      pure l
    PassedSkillTest _ _ (isAbilitySource attrs 1 -> True) SkillTestInitiatorTarget {} _ _ ->
      do
        push $ Remember DissectedAnOrgan
        pure l
    _ -> DeconstructionRoom <$> runMessage msg attrs
