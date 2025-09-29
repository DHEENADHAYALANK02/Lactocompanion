const fs = require("fs");
const translate = require("google-translate-api-x");

// Languages you want
const targetLangs = ["ta", "hi", "ar"]; // Tamil, Hindi, Arabic

// Base English file path
const baseFile = "lib/l10n/app_en.arb";
const baseData = JSON.parse(fs.readFileSync(baseFile, "utf8"));

(async () => {
  for (const lang of targetLangs) {
    let translatedData = {};

    for (const key of Object.keys(baseData)) {
      const text = baseData[key];
      try {
        const res = await translate(text, { to: lang });
        translatedData[key] = res.text;
        console.log(`✅ ${key} → ${lang}: ${res.text}`);
      } catch (err) {
        console.error(`❌ Error translating ${key} → ${lang}:`, err.message);
        translatedData[key] = text; // fallback English
      }
    }

    // Save inside lib/l10n/
    const outFile = `lib/l10n/app_${lang}.arb`;
    fs.writeFileSync(outFile, JSON.stringify(translatedData, null, 2), "utf8");
    console.log(`🌐 Saved: ${outFile}`);
  }
})();
