module Arkham.Asset.Assets.EsotericFormula (esotericFormula) where

import Arkham.Ability
import Arkham.Aspect hiding (aspect)
import Arkham.Asset.Cards qualified as Cards
import Arkham.Asset.Import.Lifted
import Arkham.Enemy.Types (Field (..))
import Arkham.Fight
import Arkham.Matcher
import Arkham.Modifier
import Arkham.Trait

newtype EsotericFormula = EsotericFormula AssetAttrs
  deriving anyclass (IsAsset, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

esotericFormula :: AssetCard EsotericFormula
esotericFormula = asset EsotericFormula Cards.esotericFormula

instance HasAbilities EsotericFormula where
  getAbilities (EsotericFormula x) =
    [ fightAbility x 1 mempty
        $ ControlsThis
        <> exists (CanFightEnemy (x.ability 1) <> EnemyWithTrait Abomination)
    ]

instance RunMessage EsotericFormula where
  runMessage msg a@(EsotericFormula attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      let source = attrs.ability 1
      sid <- getRandom
      skillTestModifier sid source iid
        $ ForEach (EnemyTargetFieldCalculation EnemyClues) [SkillModifier #willpower 2]
      aspect iid source (#willpower `InsteadOf` #combat)
        $ mkChooseFightMatch sid iid source (EnemyWithTrait Abomination)
      pure a
    _ -> EsotericFormula <$> liftRunMessage msg attrs
