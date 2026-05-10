/// <reference lib="deno.ns" />

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface PersonalityResult {
  aiRole: string;
  aiDomain: string;
}

Deno.serve(async (req: Request): Promise<Response> => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { prompt, model } = await req.json();

    if (!prompt) {
      throw new Error("Prompt is required");
    }

    const groqApiKey = Deno.env.get("GROQ_API_KEY");
    if (!groqApiKey) {
      throw new Error("GROQ_API_KEY is not configured in Supabase secrets.");
    }

    console.log("📝 Calling Groq for AI personality generation...");

    const response = await fetch(
      "https://api.groq.com/openai/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${groqApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: model || "llama-3.3-70b-versatile",
          messages: [
            {
              role: "system",
              content: `You are an expert at analyzing user personalities and learning profiles based on their answers to assessment questions.

IMPORTANT: You MUST return ONLY valid JSON with no markdown, no code blocks, no explanations.

Return JSON with these exact fields:
{
  "aiRole": "A professional title/role that matches the user's profile",
  "aiDomain": "The primary domain/field relevant to user's goals"
}

Examples:
{"aiRole": "Full Stack Developer", "aiDomain": "Web Development"}
{"aiRole": "DevOps Engineer", "aiDomain": "Infrastructure & Deployment"}
{"aiRole": "Data Scientist", "aiDomain": "Machine Learning"}`,
            },
            {
              role: "user",
              content: prompt,
            },
          ],
          temperature: 0.7,
          max_tokens: 500,
        }),
      },
    );

    if (!response.ok) {
      const errorData = await response.json();
      console.error("❌ Groq API Error:", errorData);
      throw new Error(`Groq API error: ${JSON.stringify(errorData)}`);
    }

    const data = await response.json();
    const aiResponse: string = data.choices?.[0]?.message?.content ?? "";

    if (!aiResponse) {
      throw new Error("Empty response from AI");
    }

    console.log("✅ AI Response received");

    let personality: PersonalityResult;

    try {
      const stripped = aiResponse
        .trim()
        .replace(/^```json\s*/i, "")
        .replace(/```\s*$/, "");
      personality = JSON.parse(stripped) as PersonalityResult;
    } catch {
      const jsonMatch = aiResponse.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        console.error("❌ No JSON found in response:", aiResponse);
        throw new Error("Could not parse JSON from AI response");
      }
      personality = JSON.parse(jsonMatch[0]) as PersonalityResult;
    }

    if (!personality.aiRole || !personality.aiDomain) {
      throw new Error(
        "AI response missing required fields (aiRole, aiDomain)",
      );
    }

    console.log(
      `✅ Generated Personality — Role: ${personality.aiRole}, Domain: ${personality.aiDomain}`,
    );

    return new Response(JSON.stringify(personality), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("❌ Error in generate-ai-personality function:", error);

    return new Response(
      JSON.stringify({
        error: error instanceof Error ? error.message : "Unknown error",
      }),
      {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
});
