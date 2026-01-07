import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const PROJECT_URL = Deno.env.get("PROJECT_URL");
    const SERVICE_ROLE_KEY = Deno.env.get("SERVICE_ROLE_KEY");
    const ANON_KEY = Deno.env.get("ANON_KEY");

    if (!PROJECT_URL || !SERVICE_ROLE_KEY || !ANON_KEY) {
      return new Response(
        JSON.stringify({ error: "Missing environment variables" }),
        { status: 500 }
      );
    }

    const supabaseAdmin = createClient(
      PROJECT_URL,
      SERVICE_ROLE_KEY
    );

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response("Unauthorized", { status: 401 });
    }

    const supabaseUser = createClient(
      PROJECT_URL,
      ANON_KEY,
      {
        global: {
          headers: { Authorization: authHeader },
        },
      }
    );

    const { data: { user } } = await supabaseUser.auth.getUser();

    if (!user) {
      return new Response("User not found", { status: 404 });
    }

    const userId = user.id;

    // 🔥 DELETE USER DATA
    await supabaseAdmin.from("profiles").delete().eq("id", userId);
    await supabaseAdmin.from("video_progress").delete().eq("user_id", userId);
    await supabaseAdmin.from("profile_feedback").delete().eq("user_id", userId);

    // 🔥 DELETE AUTH USER
    await supabaseAdmin.auth.admin.deleteUser(userId);

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: String(e) }),
      { status: 500 }
    );
  }
});
