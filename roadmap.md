# Coin Pincher - Flutter App Roadmap

## Overview
A coin-collecting game where players pinch a large coin on screen to earn coins. Coins are used to purchase auto-clickers, upgrades, and cosmetics.

---

## Phase 1: Core Setup & Coin Interaction
**Goal:** Get the basic app running with a tappable/pinchable coin.

- [ ] Initialize Flutter project with clean architecture (folders: `lib/screens`, `lib/widgets`, `lib/models`, `lib/providers`)
- [ ] Create `HomeScreen` with a large coin centered on screen
- [ ] Implement **pinch gesture detection** using `GestureDetector` + `ScaleGestureRecognizer`
- [ ] Award +1 coin per valid pinch (pinch-in triggers coin collection)
- [ ] Add coin counter UI at the top of the screen
- [ ] Add a simple squeeze animation on the coin when pinched (scale down + bounce back)
- [ ] Play a satisfying tap/coin sound effect on each pinch

---

## Phase 2: State Management & Persistence
**Goal:** Make coin balance persistent across sessions.

- [ ] Set up state management with `provider` (or `riverpod`)
- [ ] Create `GameState` model: `coins`, `coinsPerSecond`, `autoClickerLevel`, `selectedSkin`
- [ ] Integrate `shared_preferences` (or `hive`) for local save/load
- [ ] Auto-save state every 10 seconds and on app pause
- [ ] Restore state on app launch

---

## Phase 3: Auto-Clicker System
**Goal:** Let players buy and upgrade an auto-clicker that earns coins passively.

- [ ] Create `Shop` screen / bottom sheet accessible from the home screen
- [ ] Define auto-clicker tiers with escalating costs:
  | Level | Cost     | Coins/sec |
  |-------|----------|-----------|
  | 1     | 50       | 1         |
  | 2     | 200      | 3         |
  | 3     | 1,000    | 10        |
  | 4     | 5,000    | 30        |
  | 5     | 25,000   | 100       |
- [ ] Implement purchase logic (deduct coins, increase level)
- [ ] Run a background `Timer.periodic` that adds `coinsPerSecond` every second
- [ ] Show coins/sec indicator on the home screen
- [ ] Add visual feedback: small floating "+X" text each second from the coin

---

## Phase 4: Coin Cosmetics / Skins
**Goal:** Let players customize the look of their coin.

- [ ] Create `CosmeticsShop` screen listing available skins
- [ ] Design coin skins (assets or procedural):
  - Default Gold Coin (free)
  - Silver Coin — 500 coins
  - Diamond Coin — 5,000 coins
  - Pixel Coin — 10,000 coins
  - Rainbow Coin — 50,000 coins
  - Fire Coin — 100,000 coins
- [ ] Track purchased skins in `GameState`
- [ ] Allow equipping any purchased skin
- [ ] Update the main coin widget to render the selected skin
- [ ] Add a preview animation in the shop before buying

---

## Phase 5: Animations & Juice
**Goal:** Make the game feel satisfying and polished.

- [ ] Add particle effects on each pinch (small coin sparks flying out)
- [ ] Animate the coin counter on increment (scale pop)
- [ ] Add a subtle idle floating animation to the coin
- [ ] Screen shake on milestone achievements (every 1,000 coins)
- [ ] Background gradient that slowly shifts over time
- [ ] Haptic feedback on pinch

---

## Phase 6: Milestones & Achievements
**Goal:** Give players goals to work towards.

- [ ] Define milestone thresholds (100, 1K, 10K, 50K, 100K, 1M coins)
- [ ] Show a milestone popup/banner when reached
- [ ] Create an achievements screen listing all milestones
- [ ] Reward bonus coins or unlock exclusive skins at milestones

---

## Phase 7: Polish & Release Prep
**Goal:** Prepare for distribution.

- [ ] Design app icon (coin themed)
- [ ] Add a splash screen
- [ ] Implement settings screen (sound toggle, haptic toggle, reset progress)
- [ ] Test on multiple screen sizes and devices
- [ ] Optimize performance (minimize rebuilds, efficient timers)
- [ ] Set up proper app metadata (name, description, version)
- [ ] Build release APK / AAB for Android
- [ ] Build release IPA for iOS (if applicable)

---

## Tech Stack
| Component        | Choice                     |
|------------------|----------------------------|
| Framework        | Flutter                    |
| Language         | Dart                       |
| State Management | Provider / Riverpod        |
| Local Storage    | Hive / SharedPreferences   |
| Animations       | Flutter built-in + Rive    |
| Audio            | audioplayers               |

---

## Stretch Goals (Post-Launch)
- [ ] Multiple coin types with different pinch mechanics
- [ ] Prestige system (reset progress for permanent multipliers)
- [ ] Daily rewards / login streak
- [ ] Leaderboard (Firebase)
- [ ] Ad-supported free coins boost
