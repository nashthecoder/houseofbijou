# frozen_string_literal: true

# Maps the build-stage brief to what is live in this build.
# Single source of truth for /progress page and ?review=1 ribbons.
module ReviewNotes
  STATUS_ICONS = { done: "✅", partial: "🟡", todo: "⬜" }.freeze

  SECTIONS = {
    "Stealth architecture" => {
      status: :done,
      note: "PIN unlock behind 4 working decoy skins (Calculator, Weather, Tile match, Scores), values gate, identity onboarding, session lock.",
      screens: { "disguise/show" => "Lock screen + decoy skins — triple-tap gestures reveal the hidden PIN pad. PIN for review: 2500." }
    },
    "Panic system" => {
      status: :done,
      note: "One-tap alert with GPS capture (fallback to text location), fan-out to up to 5 circle contacts, per-contact SMS relay status, 5-minute re-arm window.",
      screens: { "panic/show" => "Arm screen. Live: geolocation + dispatch + status. Pending keys: actual SMS hand-off (logged until Africa's Talking keys are set). 🟡" }
    },
    "SMS relay" => {
      status: :partial,
      note: "Adapter written for Africa's Talking; without API keys every send is logged and marked 'held' instead of failing silently.",
      screens: {}
    },
    "Coordinator console" => {
      status: :done,
      note: "Live alert view with coordinates, contact-by-contact delivery status, alert history.",
      screens: { "coordinator/show" => "Admin view of the same alert data the circle receives." }
    },
    "Chat rooms" => {
      status: :done,
      note: "Circle chat rooms with per-message disappearing timers and automatic expiry sweep.",
      screens: {
        "chat/index" => "Room list.",
        "chat/show" => "Thread with countdown chips; messages self-destruct server- and client-side."
      }
    },
    "End-to-end encryption" => {
      status: :todo,
      note: "Post-MVP: blind relay so the server never sees plaintext. Current build stores messages server-side (deleted on expiry).",
      screens: {}
    },
    "Mutual aid board" => {
      status: :done,
      note: "Request feed, detail pages with claim ledger, fulfilment flow.",
      screens: { "aid/index" => "Feed.", "aid/show" => "Detail + ledger." }
    },
    "Community stories" => {
      status: :done,
      note: "Short updates shared with your circle only, authored under pseudonym.",
      screens: { "community/show" => "Composer + story wall." }
    },
    "Trusted circle" => {
      status: :done,
      note: "Add/remove trusted contacts with assigned colours; phone numbers collected for SMS dispatch.",
      screens: { "circle/index" => "Circle manager." }
    },
    "Identity" => {
      status: :done,
      note: "Pseudonym + avatar colour chosen at onboarding; no real names anywhere.",
      screens: { "onboarding/show" => "Identity gate after values acceptance." }
    },
    "Branding" => {
      status: :done,
      note: "Logo-palette retheme (espresso/gold/cream/sage), transparent logo, favicons only inside the unlocked app.",
      screens: {}
    },
    "Offline PWA + peer sync" => {
      status: :todo,
      note: "Post-MVP per brief: installable offline app and peer-to-peer sync are not started; current build is Postgres-backed.",
      screens: {}
    }
  }.freeze

  def self.for_page(key)
    SECTIONS.values.map { |s| s[:screens][key] }.compact.first
  end
end
