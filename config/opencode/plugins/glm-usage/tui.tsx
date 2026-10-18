import { Plugin } from "@opencode/plugin/tui"
import { createSignal } from "solid-js"
import { readFile } from "node:fs/promises"
import { homedir } from "node:os"
import { join } from "node:path"

// TUI side of the GLM usage status bar: reads the snapshot file written by
// the server plugin (index.ts) and renders it in the footer status slot.

type Quota = { pct: number }
type Snapshot = { fiveHour?: Quota; weekly?: Quota; updatedAt?: number; error?: string }

const SNAPSHOT = join(homedir(), ".local", "share", "opencode", "glm-usage.json")
const READ_MS = 60 * 1000

export default Plugin.define({
  id: "josh.glm-usage",
  setup(context) {
    const [state, setState] = createSignal("GLM …")

    const refresh = () => {
      readFile(SNAPSHOT, "utf8")
        .then((text) => {
          const s: Snapshot = JSON.parse(String(text))
          const parts: string[] = []
          if (s.fiveHour) parts.push(`5h ${s.fiveHour.pct}%`)
          if (s.weekly) parts.push(`wk ${s.weekly.pct}%`)
          setState(parts.length > 0 ? `GLM ${parts.join(" · ")}` : `GLM ${s.error ?? "…"}`)
        })
        .catch(() => {})
    }
    refresh()
    setInterval(refresh, READ_MS)

    context.ui.slot({
      append: "prompt.footer.status",
      render: () => {
        const label = state()
        const pct = Number(/5h (\d+)%/.exec(label)?.[1] ?? 0)
        const fg = pct >= 80 ? "red" : pct >= 50 ? "yellow" : "green"
        return <text fg={fg}>{label}</text>
      },
    })

    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "josh.glm-usage.status",
          title: "Show GLM quota status",
          slash: { name: "glm" },
          run: () => {
            refresh()
            context.ui.toast.show({ title: "Z.AI Coding Plan", message: state().replace(/^GLM /, "") })
          },
        },
      ],
    }))
  },
})
