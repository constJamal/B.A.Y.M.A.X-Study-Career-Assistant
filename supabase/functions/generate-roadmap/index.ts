/// <reference lib="deno.ns" />

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** Convert a human-readable duration string into an approximate number of days. */
function parseDurationToDays(duration: string): number {
  const d = duration.toLowerCase().trim();
  const num = parseInt(d.match(/\d+/)?.[0] ?? "0", 10);
  if (d.includes("month")) return num * 30;
  if (d.includes("week")) return num * 7;
  if (d.includes("day")) return num;
  return 28; // default: 1 month
}

/** Decide intensity label based on total days available. */
function intensityLabel(days: number): string {
  if (days <= 7) {
    return "HIGH-INTENSITY (very short sprint — prioritise must-know fundamentals only, 1–3 milestones)";
  }
  if (days <= 21) {
    return "MODERATE-INTENSITY (balanced — mix fundamentals with hands-on practice, 4–5 milestones)";
  }
  return "STANDARD-INTENSITY (comprehensive — include fundamentals, deep dives, and a capstone project, 6–7 milestones)";
}

/** Complexity guidance based on mastery level. */
function complexityGuidance(masteryLevel: string): string {
  const m = masteryLevel.toLowerCase();
  if (m.includes("beginner")) {
    return "BEGINNER: Start with core syntax and basic concepts. Avoid jargon. Focus on official docs, interactive tutorials, and small exercises. No advanced patterns.";
  }
  if (m.includes("intermediate")) {
    return "INTERMEDIATE: Skip trivial basics. Cover design patterns, real-world projects, and common pitfalls. Include community resources and practical repos.";
  }
  if (m.includes("expert") || m.includes("advanced") || m.includes("pro")) {
    return "EXPERT: Assume strong foundations. Cover architecture decisions, performance tuning, internals, open-source contribution, and cutting-edge tooling.";
  }
  return "INTERMEDIATE: Balanced mix of concepts and practice.";
}

/** Build the full prompt from structured inputs. */
function buildPrompt(
  topic: string,
  duration: string,
  masteryLevel: string,
): string {
  const days = parseDurationToDays(duration);
  const intensity = intensityLabel(days);
  const complexity = complexityGuidance(masteryLevel);

  return `You are an expert curriculum engineer specialising in personalised learning paths.

=== LEARNING PARAMETERS ===
Topic         : ${topic}
Mastery Level : ${masteryLevel}
Total Duration: ${duration} (≈ ${days} days)
Intensity     : ${intensity}
Complexity    : ${complexity}

=== YOUR TASK ===
Design a step-by-step learning roadmap broken into milestones.

RULES (non-negotiable):
1. Return ONLY a valid JSON array — no markdown fences, no prose, no comments.
2. Every milestone object MUST have exactly these five keys:
   { "title", "type", "url", "description", "phaseDuration" }
3. "type" must be exactly one of: doc | video | repo | project
4. "url" must be a real, working URL relevant to the topic (prefer official docs,
   GitHub repos, YouTube playlists, or reputable course pages).
5. "phaseDuration" is the time for THAT milestone (e.g. "2 days", "1 week").
6. The SUM of all phaseDuration values MUST equal exactly ${duration}.
7. Number of milestones: follow the intensity guideline above.
8. Adjust depth, URL quality, and topic coverage strictly per the mastery level.

Output the JSON array now:`;
}

// ---------------------------------------------------------------------------
// Milestone type
// ---------------------------------------------------------------------------

interface Milestone {
  title: string;
  type: string;
  url: string;
  description: string;
  phaseDuration: string;
}

// ---------------------------------------------------------------------------
// Main handler — uses Deno.serve (no std/http import required)
// ---------------------------------------------------------------------------

Deno.serve(async (req: Request): Promise<Response> => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json();

    const topic: string = body.topic ?? "";
    const duration: string = body.duration ?? "";
    const masteryLevel: string = body.masteryLevel ?? "";

    if (!topic || !duration || !masteryLevel) {
      throw new Error("topic, duration, and masteryLevel are required fields.");
    }

    const groqApiKey = Deno.env.get("GROQ_API_KEY");
    if (!groqApiKey) {
      throw new Error("GROQ_API_KEY is not configured in Supabase secrets.");
    }

    const prompt = buildPrompt(topic, duration, masteryLevel);

    console.log("🔨 generate-roadmap called");
    console.log(
      `   topic=${topic} | duration=${duration} | mastery=${masteryLevel}`,
    );
    console.log("📝 Prompt preview:", prompt.substring(0, 300) + "...");

    // Call Groq — llama-3.3-70b-versatile is fast and highly capable
    const groqRes = await fetch(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${groqApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "llama-3.3-70b-versatile",
          messages: [
            {
              role: "system",
              content:
                "You are an expert curriculum engineer. You output ONLY valid JSON arrays with no extra text.",
            },
            {
              role: "user",
              content: prompt,
            },
          ],
          temperature: 0.5,
          max_tokens: 2048,
        }),
      },
    );

    if (!groqRes.ok) {
      const errBody = await groqRes.text();
      console.error("❌ Groq API error:", errBody);
      throw new Error(`Groq API returned ${groqRes.status}: ${errBody}`);
    }

    const groqData = await groqRes.json();
    const aiText: string = groqData.choices?.[0]?.message?.content ?? "";

    if (!aiText) {
      throw new Error("Empty response from Groq.");
    }

    console.log("✅ Groq response received");
    console.log("Raw AI text (first 400 chars):", aiText.substring(0, 400));

    // --- Robust JSON extraction ---
    let milestones: Milestone[];

    try {
      const strippedText = aiText
        .trim()
        .replace(/^```json\s*/i, "")
        .replace(/```\s*$/, "");
      const parsed = JSON.parse(strippedText);
      if (!Array.isArray(parsed)) throw new Error("Parsed value is not an array.");
      milestones = parsed as Milestone[];
    } catch {
      // Fallback: grab the first [...] block
      const match = aiText.match(/\[[\s\S]*\]/);
      if (!match) {
        console.error(
          "❌ Could not extract JSON array from AI response:",
          aiText,
        );
        throw new Error(
          "AI response did not contain a parseable JSON array.",
        );
      }
      milestones = JSON.parse(match[0]) as Milestone[];
    }

    // Sanitise each milestone
    const cleaned: Milestone[] = milestones.map((item) => ({
      title: item.title || "Learning Module",
      type: (item.type || "doc").toLowerCase(),
      url:
        item.url ||
        "https://github.com/topics/" + encodeURIComponent(topic),
      description: item.description || "Continue learning.",
      phaseDuration: item.phaseDuration || "1 week",
    }));

    console.log(`✅ Returning ${cleaned.length} milestones`);
    cleaned.forEach((m, i) =>
      console.log(`   ${i + 1}. ${m.title} (${m.phaseDuration})`)
    );

    return new Response(JSON.stringify(cleaned), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Unknown error";
    console.error("❌ generate-roadmap error:", message);

    return new Response(JSON.stringify({ error: message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
