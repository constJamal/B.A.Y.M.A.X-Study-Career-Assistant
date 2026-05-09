# Supabase Edge Functions Deployment Guide

## Prerequisites

1. Supabase account and project
2. Supabase CLI installed: `npm install -g supabase`
3. Node.js 16+ installed
4. API keys (OpenAI for embeddings, or Groq for LLM)

## Setup Steps

### Step 1: Initialize Edge Functions in Your Project

```bash
# In your Baymax project root
supabase init

# Or if already initialized, navigate to functions directory
cd supabase/functions
```

### Step 2: Create Each Edge Function

#### 2.1 Career Mapping Agent

```bash
supabase functions new career-mapping-agent
```

**File:** `supabase/functions/career-mapping-agent/index.ts`

```typescript
import "https://deno.land/x/cors@v1.4.2/mod.ts";
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // CORS
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { user_input, include_market_trends, stream } = await req.json();

    // Use Groq API for LLM inference
    const systemPrompt = `You are BAYMAX, an elite Career Architect with real-time market awareness.
    Analyze the user's profile and current industry trends to suggest career paths.
    Always include relevance_score (0-1) based on market demand.
    Return JSON only.`;

    const response = await fetch(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${Deno.env.get("GROQ_API_KEY")}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "llama-3.3-70b-versatile",
          messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: user_input },
          ],
          temperature: 0.7,
          max_tokens: 2000,
        }),
      },
    );

    const data = await response.json();
    const content = data.choices?.[0]?.message?.content;
    if (!content) throw new Error("AI returned empty content");

    // Parse JSON response
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error("No JSON found in AI response");
    const careerPaths = JSON.parse(jsonMatch[0]);

    return new Response(JSON.stringify(careerPaths), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
```

#### 2.2 Skill Forge Multi-Agent

```bash
supabase functions new skill-forge-multi-agent
```

**File:** `supabase/functions/skill-forge-multi-agent/index.ts`

```typescript
import "https://deno.land/x/cors@v1.4.2/mod.ts";
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { skill_name, enable_critic } = await req.json();

    // STAGE 1: Generate roadmap
    const generatorPrompt = `Create a comprehensive learning roadmap for: ${skill_name}
    Include: skills array with skill_name, description, learning_resources, practice_projects, time_estimate
    Also include skill_dependencies map showing prerequisites`;

    const generatorResponse = await fetch(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${Deno.env.get("GROQ_API_KEY")}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "llama-3.3-70b-versatile",
          messages: [{ role: "user", content: generatorPrompt }],
          temperature: 0.7,
          max_tokens: 2000,
        }),
      },
    );

    const generatorData = await generatorResponse.json();
    const genContent = generatorData.choices?.[0]?.message?.content;
    if (!genContent) throw new Error("Roadmap generation failed");

    const roadmapMatch = genContent.match(/\{[\s\S]*\}/);
    const roadmapJson = JSON.parse(roadmapMatch ? roadmapMatch[0] : "{}");

    // STAGE 2: Critic validation
    let criticFeedback = "";
    if (enable_critic) {
      const criticPrompt = `Validate this skill roadmap for ${skill_name}:
      Check: 1) All prerequisites listed, 2) Logical skill progression, 3) Realistic time estimates
      ${JSON.stringify(roadmapJson)}
      Provide feedback on potential issues and improvements.`;

      const criticResponse = await fetch(
        "https://api.groq.com/openai/v1/chat/completions",
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${Deno.env.get("GROQ_API_KEY")}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            model: "llama-3.3-70b-versatile",
            messages: [{ role: "user", content: criticPrompt }],
            temperature: 0.5,
            max_tokens: 1000,
          }),
        },
      );

      const criticData = await criticResponse.json();
      criticFeedback = criticData.choices[0].message.content;
    }

    const result = {
      ...roadmapJson,
      critic_feedback: criticFeedback,
      generated_prompt: generatorPrompt,
    };

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
```

#### 2.3 Study Buddy RAG

```bash
supabase functions new study-buddy-rag
```

**File:** `supabase/functions/study-buddy-rag/index.ts`

```typescript
import "https://deno.land/x/cors@v1.4.2/mod.ts";
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.43.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
const supabase = createClient(supabaseUrl, supabaseServiceKey);

// Helper: Generate embedding for text
async function generateEmbedding(text: string): Promise<number[]> {
  const response = await fetch("https://api.openai.com/v1/embeddings", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      input: text,
      model: "text-embedding-3-small",
    }),
  });

  const data = await response.json();
  return data.data[0].embedding;
}

// Helper: Retrieve similar chunks using pgvector
async function retrieveSimilarChunks(
  embedding: number[],
  documentId: string,
  limit = 5,
): Promise<Array<{ text: string; page: string }>> {
  const { data, error } = await supabase.rpc("match_document_sections", {
    query_embedding: embedding,
    match_document_id: documentId,
    match_count: limit,
    similarity_threshold: 0.7,
  });

  if (error) throw error;
  return data;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { document_id } = await req.json();

    // Query: "Summarize this document"
    const query = "Provide a comprehensive summary of the document";
    const queryEmbedding = await generateEmbedding(query);

    // Retrieve relevant chunks using RAG
    const relevantChunks = await retrieveSimilarChunks(
      queryEmbedding,
      document_id,
      5,
    );

    // Generate summary grounded in chunks
    const context = relevantChunks.map((c) => c.text).join("\n\n");
    const systemPrompt = `You are a study assistant. Summarize the following document chunks:
    ${context}
    
    Provide a clear, concise summary with key takeaways. Track which chunks you used for each point.`;

    const response = await fetch(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${Deno.env.get("GROQ_API_KEY")}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "llama-3.3-70b-versatile",
          messages: [{ role: "user", content: systemPrompt }],
          temperature: 0.5,
          max_tokens: 1500,
        }),
      },
    );

    const data = await response.json();
    const summary = data.choices[0].message.content;

    // Extract citations from relevant chunks
    const citations = relevantChunks.map((chunk, index) => ({
      text: chunk.text.substring(0, 200),
      page: chunk.page || "Unknown",
      document_section: `Chunk ${index + 1}`,
      start_index: 0,
      end_index: 200,
    }));

    return new Response(
      JSON.stringify({
        summary,
        citations,
        source_document_id: document_id,
        generated_at: new Date().toISOString(),
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
```

### Step 3: Deploy Edge Functions

```bash
# Login to Supabase
supabase login

# Deploy all functions
supabase functions deploy

# Or deploy specific function
supabase functions deploy career-mapping-agent

# Check deployment status
supabase functions list
```

### Step 4: Set Environment Variables

In Supabase console → Edge Functions → Settings:

```
GROQ_API_KEY=your_groq_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
```

### Step 5: Create pgvector for RAG

```sql
-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create documents table
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  file_name TEXT NOT NULL,
  file_path TEXT NOT NULL,
  total_chunks INT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create embeddings table
CREATE TABLE document_embeddings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  chunk_index INT NOT NULL,
  chunk_text TEXT NOT NULL,
  embedding vector(1536),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create index for similarity search
CREATE INDEX idx_embeddings_vector ON document_embeddings
  USING IVFFLAT (embedding vector_cosine_ops)
  WITH (lists = 100);

-- Create RLS policies
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their documents"
  ON documents FOR ALL
  USING (auth.uid() = user_id);

ALTER TABLE document_embeddings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only access their embeddings"
  ON document_embeddings FOR ALL
  USING (
    document_id IN (
      SELECT id FROM documents WHERE user_id = auth.uid()
    )
  );

-- Create function for similarity search
CREATE OR REPLACE FUNCTION match_document_sections(
  query_embedding vector(1536),
  match_document_id UUID,
  match_count INT DEFAULT 5,
  similarity_threshold FLOAT DEFAULT 0.7
)
RETURNS TABLE (
  text TEXT,
  page TEXT,
  similarity FLOAT
)
LANGUAGE SQL STABLE
AS $$
  SELECT
    de.chunk_text AS text,
    (de.metadata->>'page')::TEXT AS page,
    1 - (de.embedding <=> query_embedding) AS similarity
  FROM document_embeddings de
  WHERE de.document_id = match_document_id
  AND 1 - (de.embedding <=> query_embedding) > similarity_threshold
  ORDER BY de.embedding <=> query_embedding
  LIMIT match_count;
$$;
```

### Step 6: Test Edge Functions

```bash
# Test locally
supabase functions serve

# In another terminal
curl -X POST http://localhost:54321/functions/v1/career-mapping-agent \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"user_input": "I know Flutter", "include_market_trends": true}'
```

### Step 7: Monitor Edge Functions

```bash
# View logs
supabase functions list-deployed

# Check specific function logs in Supabase console:
# Edge Functions → Logs
```

## Best Practices

1. **Error Handling**: Return descriptive JSON errors
2. **CORS**: Always handle OPTIONS requests
3. **Timeouts**: Keep functions < 60 seconds
4. **Security**: Use Supabase service role key for sensitive operations
5. **Secrets**: Never commit API keys - use environment variables
6. **Testing**: Test locally before deploying
7. **Logging**: Use `console.log` for debugging
8. **Performance**: Cache embeddings, use batch operations

## Troubleshooting

**Error: "Function not found"**

- Ensure deployed correctly: `supabase functions deploy`
- Check function name matches

**Error: "401 Unauthorized"**

- Verify API keys in environment variables
- Check Bearer token in request

**Error: "Timeout exceeded"**

- Optimize query performance
- Use pagination for large datasets
- Consider async processing

**pgvector Performance Issues**

- Rebuild index: `REINDEX INDEX idx_embeddings_vector;`
- Check similarity threshold
- Use LIMIT clause

---

**Deployment Checklist:**

- [ ] Create all edge functions
- [ ] Test locally
- [ ] Set API keys as environment variables
- [ ] Create pgvector tables and indexes
- [ ] Configure RLS policies
- [ ] Deploy to production
- [ ] Monitor logs for errors
- [ ] Set up alerts
