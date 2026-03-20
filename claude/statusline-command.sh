#!/bin/sh
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
basename=$(basename "$cwd")

# Git branch (skip optional locks to avoid interfering with running git processes)
git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // .model.id // empty')

# Context usage: input tokens used / context window size
used=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
total=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Build the status line
status="$basename"

if [ -n "$git_branch" ]; then
  status="$status  $git_branch"
fi

if [ -n "$model" ]; then
  status="$status  $model"
fi

if [ -n "$used" ] && [ -n "$total" ]; then
  status="$status  ${used}/${total} tokens"
fi

printf '%s' "$status"
