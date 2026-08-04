#!/bin/sh
# Load Jira creds from gitignored .env, then launch the MCP server.
set -a
. "$(dirname "$0")/.env"
set +a
exec npx -y @aashari/mcp-server-atlassian-jira
