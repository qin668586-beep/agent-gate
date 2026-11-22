// 本地起静态服务 + 用 puppeteer 截图 AgentGate 页面，验证渲染与脚本无错。
import fs from "node:fs";
import http from "node:http";
import path from "node:path";
import { createRequire } from "node:module";
const require = createRequire("D:/learn_AI/.runtime/pptr/");
const puppeteer = require("puppeteer-core");

const ROOT = "D:/learn_AI/hackathon/agent-gate";
const PORT = 8899;

const types = { ".html": "text/html; charset=utf-8", ".js": "text/javascript", ".css": "text/css", ".png": "image/png", ".sol": "text/plain; charset=utf-8", ".md": "text/plain; charset=utf-8" };
const server = http.createServer((req, res) => {
  const p = decodeURIComponent((req.url || "/").split("?")[0]);
  const file = path.join(ROOT, p === "/" ? "index.html" : p);
  fs.readFile(file, (e, buf) => {
    if (e) { res.writeHead(404); res.end("not found"); return; }
    res.writeHead(200, { "content-type": types[path.extname(file).toLowerCase()] || "application/octet-stream" });
    res.end(buf);
  });
});
await new Promise((r) => server.listen(PORT, "127.0.0.1", r));

const CANDIDATES = [
  "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
  "C:/Program Files/Microsoft/Edge/Application/msedge.exe",
  "C:/Program Files/Google/Chrome/Application/chrome.exe",
];
const exe = CANDIDATES.find((p) => fs.existsSync(p));
if (!exe) { console.error("no browser"); process.exit(2); }

const browser = await puppeteer.launch({
  executablePath: exe,
  headless: "new",
  args: ["--no-sandbox", "--disable-gpu", "--proxy-server=http://127.0.0.1:7892", "--window-size=1280,1400"],
  defaultViewport: { width: 1280, height: 1400 },
});
const page = await browser.newPage();
const errs = [];
page.on("pageerror", (e) => errs.push("pageerror: " + e.message));
page.on("console", (m) => { if (m.type() === "error") errs.push("console: " + m.text().slice(0, 200)); });
page.on("requestfailed", (r) => errs.push("reqfail: " + r.url().slice(0, 90) + " " + (r.failure()?.errorText || "")));

await page.goto(`http://127.0.0.1:${PORT}/`, { waitUntil: "networkidle2", timeout: 60000 });
await new Promise((r) => setTimeout(r, 3000));

const info = await page.evaluate(() => ({
  h1: (document.querySelector("h1") || {}).textContent || "",
  addr: (document.querySelector("#addr") || {}).textContent?.slice(0, 40),
  total: (document.querySelector("#total") || {}).textContent,
  unique: (document.querySelector("#unique") || {}).textContent,
  today: (document.querySelector("#today") || {}).textContent,
  btnConnect: (document.querySelector("#connect") || {}).textContent,
  hasEthereum: typeof window.ethereum !== "undefined",
  scrollW: document.documentElement.scrollWidth,
  bodyH: document.body.scrollHeight,
  ethersLoaded: !!document.querySelector("script[type=module]"),
}));
console.log(JSON.stringify(info, null, 2));
const out = process.argv[2] || "D:/learn_AI/hackathon/agent-gate/ship-shot.png";
await page.screenshot({ path: out, fullPage: true });
console.log("shot ->", out, "bytes=" + fs.statSync(out).size);
if (errs.length) console.log("ERR:\n" + errs.slice(0, 8).join("\n")); else console.log("no errors");
await browser.close();
server.close();
