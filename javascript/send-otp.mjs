// Send an OTP code with Resala using the built-in fetch (Node 18+, Deno, Bun).
// Usage: RESALA_API_KEY=... node send-otp.mjs 218910001234
const phone = process.argv[2] ?? "218910001234";
const apiKey = process.env.RESALA_API_KEY;
if (!apiKey) throw new Error("Set RESALA_API_KEY");

const url = new URL("https://dev.resala.ly/api/v1/pins");
url.searchParams.set("service_name", "MyApp");
// url.searchParams.set("test", "");        // test mode: nothing sent, nothing charged
// url.searchParams.set("sender", "MyBrand"); // registered sender name

const res = await fetch(url, {
  method: "POST",
  headers: { Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json" },
  body: JSON.stringify({ phone }),
});
const data = await res.json();

if (!res.ok) {
  // Branch on data.type (e.g. InsufficientCredit, InputValidation), not on data.message.
  throw new Error(`${res.status} ${data.type}: ${data.message} (request_id ${data.request_id})`);
}

// Store data.pin server-side and compare it with what the user types; enforce your own expiry.
console.log("sent", data.id, "pin", data.pin, "sender", data.sender_name);
