import { Plugin } from "@opencode/plugin"
import { writeFile, readFile } from "node:fs/promises"
import { homedir } from "node:os"
import { join } from "node:path"

// Server side of the GLM usage status bar: polls the Z.AI coding-plan quota
// API every few minutes and writes a snapshot file that the TUI plugin
// (tui.tsx) renders in the footer. Note: keep this setup() side-effect-free
// and non-throwing — a failing server plugin suppresses the plugin's UI in
// all connected clients.

const SNAPSHOT = join(homedir(), ".local", "share", "opencode", "glm-usage.json")
const API_BASE = "https://api.z.ai"
const POLL_MS = 5 * 60 * 1000

function clamp(v: unknown): number {
  return Math.max(0, Math.min(100, Math.round(Number(v) || 0)))
}

function readApiKey(): Promise<string | undefined> {
  const dataHome = process.env.XDG_DATA_HOME || join(homedir(), ".local", "share")
  return readFile(join(dataHome, "opencode", "auth.json"), "utf8")
    .then((text) => {
      const auth = JSON.parse(text)
      const entry = auth["zai-coding-plan"] ?? auth["zai"]
      const key = entry?.key
      if (typeof key === "string" && key.length > 0) return key
      return process.env.ZAI_API_KEY || undefined
    })
    .catch(() => process.env.ZAI_API_KEY || undefined)
}

type Snapshot = { fiveHour?: { pct: number }; weekly?: { pct: number }; updatedAt?: number; error?: string }

function poll(): Promise<Snapshot> {
  return readApiKey()
    .then((key) => {
      if (!key) throw new Error("no key")
      return fetch(`${API_BASE}/api/monitor/usage/quota/limit`, {
        headers: { Authorization: key, "Accept-Language": "en-US" },
        signal: AbortSignal.timeout(10_000),
      })
    })
    .then((res) => {
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      return res.json()
    })
    .then((json: { data?: { limits?: Array<Record<string, unknown>> } }) => {
      const limits = json?.data?.limits ?? []
      const tokens = limits.find((l) => l.type === "TOKENS_LIMIT")
      const time = limits.find((l) => l.type === "TIME_LIMIT")
      return {
        fiveHour: tokens ? { pct: clamp(tokens.percentage) } : undefined,
        weekly: time ? { pct: clamp(time.percentage) } : undefined,
        updatedAt: Date.now(),
      }
    })
    .catch((err: unknown) => ({ error: err instanceof Error ? err.message : String(err) }))
}

function publish(): void {
  poll()
    .then((snapshot) => writeFile(SNAPSHOT, JSON.stringify(snapshot)))
    .catch(() => {})
}

export default Plugin.define({
  id: "josh.glm-usage",
  setup() {
    publish()
    setInterval(publish, POLL_MS)
  },
})
