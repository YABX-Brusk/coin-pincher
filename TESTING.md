# Testing Coin Pincher - 3 Modes

## Mode 1: Windows Desktop (Fastest to try)

Since you're on Windows with Flutter installed, you can run directly on desktop.

```bash
flutter run -d windows
```

**How to test pinch on desktop:**
- Desktop doesn't support real pinch gestures, but you can simulate using **two mouse buttons** or **trackpad pinch** if your laptop supports it.
- Alternatively, for quick testing, you can temporarily change the pinch threshold in `lib/widgets/coin_widget.dart` line 65:
  ```dart
  // Change this:
  if (details.scale < 0.85 && !_isPinching) {
  // To this for click-to-collect testing:
  if (details.scale != 1.0 && !_isPinching) {
  ```
  Then a simple click/scroll on the coin will trigger collection. **Remember to revert before building for mobile.**

**What to verify:**
1. App launches with dark background and gold coin centered
2. Coin counter shows "0" and "COINS" label
3. SHOP button visible at the bottom
4. Tap SHOP -> bottom sheet opens with 5 auto-clicker tiers
5. Collect 50+ coins -> buy "Rusty Clicker" -> coins/sec indicator appears
6. Floating "+1" text animates upward every second
7. Close and reopen the app -> coins should persist

---

## Mode 2: Android Emulator

```bash
flutter emulators --launch <emulator_name>
flutter run -d emulator-5554
```

Or if you have Android Studio installed:
1. Open Android Studio -> Device Manager -> Create/Start an emulator
2. Run `flutter run` (it auto-detects the emulator)

**How to test pinch on emulator:**
- Hold **Ctrl** (or **Cmd** on Mac) and **click + drag** on the coin to simulate a pinch gesture
- Drag **inward** toward the coin center to pinch-in (this triggers coin collection)

**What to verify:**
1. All items from Mode 1
2. Pinch gesture works naturally with two-finger simulation
3. Haptic feedback triggers (you'll see a log, emulator may not vibrate)
4. Coin sound plays on each pinch
5. Background the app (Home button) -> reopen -> state persists
6. Buy multiple auto-clicker tiers -> verify coins/sec increases correctly

---

## Mode 3: Physical Android Device (Best experience)

```bash
flutter run -d <device_id>
```

**Setup:**
1. Enable **Developer Options** on your phone (Settings -> About -> tap Build Number 7 times)
2. Enable **USB Debugging** in Developer Options
3. Connect phone via USB cable
4. Run `flutter devices` to verify it's detected
5. Run `flutter run`

**How to test pinch on real device:**
- Place two fingers on the coin and **pinch inward** (like zooming out on a photo)
- The coin should squeeze, play a sound, vibrate, and add +1 coin

**What to verify:**
1. All items from Mode 1 and Mode 2
2. **Real pinch gesture** feels responsive and satisfying
3. **Haptic feedback** actually vibrates the phone
4. **Sound effect** plays through speakers
5. Auto-clicker floating text is smooth at 60fps
6. App survives being killed and relaunched (persistence)
7. Buy all 5 tiers sequentially:
   - Tier 1 (50 coins) -> 1/sec
   - Tier 2 (200 coins) -> 3/sec
   - Tier 3 (1K coins) -> 10/sec
   - Tier 4 (5K coins) -> 30/sec
   - Tier 5 (25K coins) -> 100/sec

---

## Quick Cheat: Give yourself coins for testing

To skip grinding while testing the shop, temporarily add this to `lib/providers/game_provider.dart` inside `loadState()`, right before `notifyListeners();`:

```dart
_state.coins = 50000; // Remove after testing!
```

This gives you 50K coins on every launch so you can test all shop tiers quickly.
