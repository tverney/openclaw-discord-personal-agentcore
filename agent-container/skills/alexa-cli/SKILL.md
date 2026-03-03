---
name: alexa-cli
description: "Control Amazon Alexa devices and smart home via the `alexacli` CLI. Use when a user asks to speak/announce on Echo devices, control lights/thermostats/locks, send voice commands, or query Alexa."
metadata: { "openclaw": { "emoji": "🔊", "requires": { "bins": ["alexacli"] } } }
---

# Alexa CLI

Control Amazon Echo devices and smart home via the unofficial Alexa API using `alexacli`.

## When to Use

✅ **USE this skill when:**

- User asks to speak or announce something on Echo devices
- Control smart home devices (lights, thermostat, locks, music)
- Send voice commands to Alexa
- Query Alexa for information (weather, calendar, timers)
- Interact with Alexa+ LLM conversations

❌ **DON'T use this skill when:**

- User asks about Alexa Skills Kit development (that's AWS SDK)
- General smart home questions not involving Echo devices

## Commands

### Text-to-Speech
```bash
# Speak on a specific device
alexacli speak "Hello world" -d "Kitchen Echo"

# Announce to ALL devices
alexacli speak "Dinner is ready!" --announce
```

### Voice Commands (Smart Home)
```bash
# Lights
alexacli command "turn off the living room lights" -d Kitchen

# Thermostat
alexacli command "set thermostat to 72 degrees" -d Bedroom

# Music
alexacli command "play jazz music" -d "Living Room"

# Questions
alexacli command "what's the weather" -d Kitchen
```

### Ask (Get Response Back)
```bash
alexacli ask "what's the thermostat set to" -d Kitchen
alexacli ask "what's on my calendar today" -d Kitchen --json
```

### Alexa+ (LLM Conversations)
```bash
alexacli askplus -d "Echo Show" "What's the capital of France?"
alexacli conversations
alexacli fragments "amzn1.conversation.xxx"
```

### Device Management
```bash
alexacli devices
alexacli devices --json
```

### Audio Playback
```bash
alexacli play --url "https://example.com/audio.mp3" -d "Echo Show"
```

### History
```bash
alexacli history
alexacli history --limit 5 --json
```

### Auth Status
```bash
alexacli auth status
alexacli auth status --verify
```

## Notes

- Refresh token valid ~14 days, credentials auto-restored from S3 on container start
- Device names support partial, case-insensitive matching
- For AI/agentic use, `alexacli command` with natural language is preferred
- Add `--verbose` or `-v` to any command for debug output
