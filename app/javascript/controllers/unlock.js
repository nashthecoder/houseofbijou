// Shared stealth-unlock helpers used by whichever disguise skin is active.

const UNLOCK_DESTINATIONS = {
  ok: "/dashboard",
  values: "/values",
  onboarding: "/onboarding"
}

export async function attemptUnlock(code) {
  const token = document.querySelector('meta[name="csrf-token"]')?.content
  try {
    const response = await fetch("/unlock", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": token ?? ""
      },
      body: JSON.stringify({ code })
    })
    if (!response.ok) return null
    const data = await response.json()
    return UNLOCK_DESTINATIONS[data.status] ?? null
  } catch {
    return null
  }
}

export function dissolveThenVisit(destination) {
  const frame = document.getElementById("disguise-view")
  if (frame) frame.classList.add("disguise-dissolve")
  setTimeout(() => Turbo.visit(destination), 280)
}
