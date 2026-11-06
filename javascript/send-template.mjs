// Send an approved template to one or more Libyan numbers.
// Usage: RESALA_API_KEY=... node send-template.mjs TEMPLATE_ID 218910001234
const [templateId, phone = "218910001234"] = process.argv.slice(2);
if (!templateId) throw new Error("Usage: node send-template.mjs TEMPLATE_ID PHONE");

const url = `https://dev.resala.ly/api/v1/messages/send-template?sms_template_id=${encodeURIComponent(templateId)}`;
const res = await fetch(url, {
  method: "POST",
  headers: { Authorization: `Bearer ${process.env.RESALA_API_KEY}`, "Content-Type": "application/json" },
  body: JSON.stringify({
    records: [
      { phone, $1: "Resala", $2: "Ahmed" },
      // { phone, $1: "Resala", $2: "Sara", scheduled_at: "2026-11-20 09:00" }, // per-record schedule (Libya time)
    ],
  }),
});
const data = await res.json();
if (!res.ok) throw new Error(`${res.status} ${data.type}: ${data.message}`);
console.log(`sent ${data.succeeded}, failed ${data.failed}, cost ${data.total_cost} LYD`, data.invalid_numbers);
