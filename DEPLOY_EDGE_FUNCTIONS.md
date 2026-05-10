# Deploy Guide - Supabase Edge Functions

## Prerequisites

1. **Supabase CLI** - Install from https://supabase.com/docs/guides/cli
2. **Deno Runtime** - Installed with Supabase CLI
3. **OpenAI API Key** - Get from https://platform.openai.com/api-keys
4. **Supabase Account** - Already set up with project at: https://hgczeuvkkqqjsqmbhozp.supabase.co

## Step 1: Set Up Local Environment

```bash
# Navigate to project root
cd c:\Users\Lenovo\OneDrive\Desktop\baymax

# Initialize Supabase locally (if not already done)
supabase init

# Create .env.local file for local development
# This file should contain:
OPENAI_API_KEY=your-openai-api-key-here

# Link to your Supabase project
supabase link --project-ref hgczeuvkkqqjsqmbhozp
```

## Step 2: Configure Supabase Secrets

Set the OpenAI API key as a secret in your Supabase project:

```bash
# Use Supabase CLI to set the secret
supabase secrets set OPENAI_API_KEY=your-openai-api-key-here
```

Or set it via Supabase Dashboard:

1. Go to https://supabase.com/dashboard
2. Select your project (hgczeuvkkqqjsqmbhozp)
3. Go to Settings → Edge Functions → Secrets
4. Add `OPENAI_API_KEY` with your OpenAI API key

## Step 3: Test Locally (Optional)

```bash
# Start Supabase local development server
supabase start

# In another terminal, test the function
curl -X POST http://localhost:54321/functions/v1/generate-roadmap \
  -H "Authorization: Bearer your-anon-key" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Create a learning path for Flutter in 2 weeks for beginners", "model": "gpt-4"}'

# To stop:
supabase stop
```

## Step 4: Deploy to Production

```bash
# Deploy both Edge Functions to production
supabase functions deploy generate-roadmap
supabase functions deploy generate-ai-personality
```

You should see output like:

```
✓ Function generate-roadmap deployed successfully
✓ Function generate-ai-personality deployed successfully
```

## Step 5: Verify Deployment

The functions are now live at:

- `https://hgczeuvkkqqjsqmbhozp.supabase.co/functions/v1/generate-roadmap`
- `https://hgczeuvkkqqjsqmbhozp.supabase.co/functions/v1/generate-ai-personality`

Test with:

```bash
curl -X POST https://hgczeuvkkqqjsqmbhozp.supabase.co/functions/v1/generate-roadmap \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnY3pldXZra3FxanNxbWJob3pwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NTUxNzgsImV4cCI6MjA5MjUzMTE3OH0.LjYFuHScuHVZfYBvxq6pJfmklIiVAMhheEALvwSlIIU" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Create a learning path for Flutter in 2 weeks for beginners", "model": "gpt-4"}'
```

## What Each Function Does

### generate-roadmap

- **Purpose**: Creates AI-driven learning curriculums with specific phase durations
- **Input**: User's topic, mastery level, total duration
- **Output**: Array of curriculum items with phase durations that sum to total duration
- **Uses**: GPT-4 to intelligently split learning into phases

### generate-ai-personality

- **Purpose**: Generates user personality profile based on onboarding answers
- **Input**: 10 onboarding questions answered by user
- **Output**: AI role and domain recommendations
- **Uses**: GPT-4 to analyze profile and suggest matching roles

## Troubleshooting

### "OPENAI_API_KEY not configured"

- Make sure you've set the secret in Supabase Dashboard
- After setting, it takes a few seconds to propagate
- Redeploy functions after setting secrets: `supabase functions deploy generate-roadmap`

### "401 Unauthorized"

- Check your Supabase anon key (from constants.dart)
- Verify the Authorization header format: `Bearer YOUR_KEY`

### Function returns empty response

- Check the Supabase Dashboard Edge Functions logs
- Look for errors in the function execution

### ChatGPT API timeout

- Edge Functions have a 60-second timeout
- GPT-4 requests should complete within 45 seconds
- If timing out, consider switching to a faster model like GPT-3.5-turbo

## Next Steps

1. Get your OpenAI API key from https://platform.openai.com
2. Run: `supabase secrets set OPENAI_API_KEY=your-key`
3. Run: `supabase functions deploy generate-roadmap generate-ai-personality`
4. Test from the Flutter app
5. Check console logs for debugging (use `print()` in Flutter and check browser console)
