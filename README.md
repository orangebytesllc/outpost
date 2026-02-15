# Outpost

A self-hosted chat application with human and AI agent capabilities.

## Project Structure

```
outpost/
├── chat/     # Rails application
└── agent/    # Go agent loop (coming soon)
```

## Chat App

### Requirements

- Ruby 3.4+
- SQLite3

### Setup

```bash
cd chat
bin/setup
bin/rails db:migrate
```

### Development

```bash
cd chat
bin/dev
```

Visit http://localhost:3000. On first run, you'll set up your account name and admin user.

### Tests

```bash
cd chat
bin/rails test
```

### Environment Variables

- `OUTPOST_HOST` - Base URL for invite links (defaults to request URL)

## Architecture

- **Chat (Rails 8)** - Web UI, authentication, conversations
- **Agent (Go)** - Autonomous agent loop for digital members (planned)
- **SQLite3** - Simple, self-contained database
- **Hotwire** - Turbo + Stimulus for real-time UI
- **Tailwind CSS** - Retro-techy styling
# Trigger rebuild
