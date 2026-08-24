module IconHelper
  ICONS = {
    "history" => '<path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/><path d="M12 7v5l4 2"/>',
    "eye-off" => '<path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" x2="22" y1="2" y2="22"/>',
    "arrow-right" => '<path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>',
    "arrow-left" => '<path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>',
    "lock-keyhole" => '<rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
    "timer" => '<line x1="10" x2="14" y1="2" y2="2"/><line x1="12" x2="15" y1="14" y2="11"/><circle cx="12" cy="14" r="8"/>',
    "send" => '<path d="m22 2-7 20-4-9-9-4Z"/><path d="M22 2 11 13"/>',
    "plus" => '<path d="M5 12h14"/><path d="M12 5v14"/>',
    "arrow-up" => '<path d="m5 12 7-7 7 7"/><path d="M12 19V5"/>',
    "home" => '<path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>',
    "circle-dot" => '<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="1"/>',
    "message-circle" => '<path d="m3 21 1.9-5.7a8.5 8.5 0 1 1 3.8 3.8z"/>',
    "heart-handshake" => '<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/><path d="M12 5 9.04 7.96a2.17 2.17 0 0 0 0 3.08v0c.82.82 2.13.85 3 .07l2.07-1.9a2.82 2.82 0 0 1 3.79 0l2.96 2.66"/><path d="m18 15-2-2"/><path d="m15 18-2-2"/>',
    "settings-2" => '<path d="M20 7h-9"/><path d="M14 17H5"/><circle cx="17" cy="17" r="3"/><circle cx="7" cy="7" r="3"/>'
  }.freeze

  def icon(name, size: 18, css_class: nil)
    body = ICONS.fetch(name) { raise ArgumentError, "unknown icon #{name}" }
    classes = [ "lucide", css_class ].compact.join(" ")
    %(<svg xmlns="http://www.w3.org/2000/svg" width="#{size}" height="#{size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="#{classes}" aria-hidden="true">#{body}</svg>).html_safe
  end
end
