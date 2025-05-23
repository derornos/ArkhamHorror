module Arkham.Asset.Assets.SergeantMonroe (sergeantMonroe) where

import Arkham.Ability
import Arkham.Asset.Cards qualified as Cards
import Arkham.Asset.Runner
import Arkham.DamageEffect
import Arkham.Helpers.Modifiers
import Arkham.Matcher
import Arkham.Prelude
import Arkham.Trait (Trait (Innocent))
import Arkham.Window (Window (..))
import Arkham.Window qualified as Window

newtype SergeantMonroe = SergeantMonroe AssetAttrs
  deriving anyclass IsAsset
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

sergeantMonroe :: AssetCard SergeantMonroe
sergeantMonroe = ally SergeantMonroe Cards.sergeantMonroe (3, 3)

instance HasModifiersFor SergeantMonroe where
  getModifiersFor (SergeantMonroe a) =
    modifySelect
      a
      (not_ (HasMatchingAsset (be a)) <> at_ (locationWithAsset a))
      [CanAssignDamageToAsset a.id, CanAssignHorrorToAsset a.id]

instance HasAbilities SergeantMonroe where
  getAbilities (SergeantMonroe attrs) =
    [ restricted
        attrs
        1
        (OnSameLocation <> exists (EnemyAt YourLocation <> EnemyWithoutTrait Innocent))
        $ triggered (AssetDealtDamageOrHorror #when AnySource (be attrs)) (exhaust attrs)
    ]

getDamage :: [Window] -> Int
getDamage ((windowType -> Window.DealtDamage _ _ _ n) : rest) = n + getDamage rest
getDamage (_ : rest) = getDamage rest
getDamage [] = 0

getHorror :: [Window] -> Int
getHorror ((windowType -> Window.DealtHorror _ _ n) : rest) = n + getHorror rest
getHorror (_ : rest) = getHorror rest
getHorror [] = 0

instance RunMessage SergeantMonroe where
  runMessage msg a@(SergeantMonroe attrs) = case msg of
    UseCardAbility iid (isSource attrs -> True) 1 windows' _ -> do
      let damage = getDamage windows'
      let horror = getHorror windows'
      enemies <- select $ enemyAtLocationWith iid <> EnemyWithoutTrait Innocent
      player <- getPlayer iid
      let deal n =
            chooseOrRunOne player
              $ targetLabels enemies
              $ only
              . (`EnemyDamage` nonAttack (Just iid) (toAbilitySource attrs 1) n)
      push
        $ chooseOrRunOne player
        $ [Label ("Deal damage dealt (" <> tshow damage <> ")") [deal damage] | damage > 0]
        <> [Label ("Deal horror dealt (" <> tshow horror <> ")") [deal horror] | horror > 0]
      pure a
    _ -> SergeantMonroe <$> runMessage msg attrs
