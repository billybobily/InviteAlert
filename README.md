# Group Invite Alert

*"Sorry, I'm already in a group!" - Every player you try to invite*

For World of Warcraft Classic (1.12)

Group Invite Alert is a simple but useful addon that automatically notifies players when you try to invite them but they're already in a group. No more awkward silence - they'll know you tried to reach them!

## Why this addon?

When you try to invite someone who's already in a group, you get an error message but the other player has no idea you tried to invite them. This addon bridges that gap by automatically sending them a friendly whisper letting them know you attempted to invite them.

## What it does

Group Invite Alert monitors your invite attempts and the game's error messages. When you try to invite a player who is already in a group, it automatically sends them a customizable whisper message. Simple, lightweight, and effective.

## How to use it

**Basic Usage:**

The addon works automatically! Just try to invite someone:
- `/invite PlayerName` - or any other method to invite
- If they're already in a group, they'll automatically receive your whisper

**Slash Commands:**

Configure the addon with these commands:
- `/gia` or `/groupinvitealert` - Show help and available commands
- `/gia on` or `/gia enable` - Enable the addon
- `/gia off` or `/gia disable` - Disable the addon
- `/gia status` - Show current status and your custom message
- `/gia msg <your message>` - Set a custom whisper message

**Default Message:**

"Hey! I tried to invite you but you're already in a group. Let me know when you're free!"

**Customizing Your Message:**

Want to personalize your auto-whisper? Use the `/gia msg` command:

```
/gia msg Hey! Tried to invite you for a dungeon run. Message me when you're available!
```

The addon will remember your custom message across sessions.

## Examples

**Scenario: Raid formation**
```
/gia msg We're forming for MC tonight at 7pm, whisper me when available!
/invite Warriorname
```
The warrior will know you're looking for them even if they're currently grouped.

## Compatibility

- **WoW Version:** Classic 1.12 (Vanilla)
- **Lua Version:** 5.0 (Classic-compatible)
- **Works with:** Any Classic WoW client

## Installation

1. Download or copy the `GroupInviteAlert` folder
2. Place it in your `World of Warcraft/Interface/AddOns/` directory
3. Restart WoW or reload your UI (`/reload`)
4. The addon will confirm it's loaded with a green message

## Author

Created by BillyBobily for the Classic WoW community.
