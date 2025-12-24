# Billy's Invite Alert

*"That player is already in a group." - Every player you try to invite*

For World of Warcraft Classic (1.12)

Billy's Invite Alert is a simple but useful addon that automatically notifies players when you try to invite them but they're already in a group. No more awkward silence - they'll know you tried to reach them!

## Why this addon?

When you try to invite someone who's already in a group, you get an error message but the other player has no idea you tried to invite them. This addon bridges that gap by automatically sending them a friendly whisper letting them know you attempted to invite them.

## What it does

Billy's Invite Alert monitors your invite attempts and the game's error messages. When you try to invite a player who is already in a group, it automatically sends them a customizable whisper message. Simple, lightweight, and effective.

**Smart Group Detection:** The addon checks if the player is already in your party or raid before sending a whisper. If someone else has already invited them, you'll see a message letting you know they're already grouped with you instead of sending an unnecessary whisper.

## How to use it

**Basic Usage:**

The addon works automatically! Just try to invite someone:
- `/invite PlayerName` - or any other method to invite
- If they're already in a group, they'll automatically receive your whisper

**Slash Commands:**

Configure the addon with these commands:
- `/bia` or `/billyinvitealert` - Show help and available commands
- `/bia on` or `/bia enable` - Enable the addon
- `/bia off` or `/bia disable` - Disable the addon
- `/bia status` - Show current status and your custom message
- `/bia msg <your message>` - Set a custom whisper message

**Default Message:**

"Hey! I tried to invite you but you're already in a group. Let me know when you're free!"

**Customizing Your Message:**

Want to personalize your auto-whisper? Use the `/bia msg` command:

```
/bia msg Hey! Tried to invite you for a dungeon run. Message me when you're available!
```

The addon will remember your custom message across sessions.

## Examples

**Scenario: Raid formation**
```
/bia msg We're forming for MC tonight at 7pm, whisper me when available!
/invite Warriorname
```
The warrior will know you're looking for them even if they're currently grouped.

**Scenario: Duplicate invites**
If you try to invite someone but another raid member has already invited them, the addon detects this and shows: "Billy's Invite Alert: PlayerName is already in your group!" - no whisper is sent.

## Compatibility

- **WoW Version:** Classic 1.12 (Vanilla)
- **Lua Version:** 5.0 (Classic-compatible)
- **Works with:** Any Classic WoW client

## Installation

1. Download or copy the `BillyInviteAlert` folder
2. Place it in your `World of Warcraft/Interface/AddOns/` directory
3. Restart WoW or reload your UI (`/reload`)
4. The addon will confirm it's loaded with a green message

## Author

Created by BillyBobily for the Classic WoW community.
