module NavigationHelper
  NAV_ITEMS = [
    { key: "dashboard", label: "Home",     icon: "home",           path: "/dashboard" },
    { key: "circle",    label: "Circle",   icon: "circle-dot",     path: "/circle" },
    { key: "chat",      label: "Chat",     icon: "message-circle", path: "/chat" },
    { key: "aid",       label: "Aid",      icon: "heart-handshake", path: "/aid" },
    { key: "settings",  label: "Settings", icon: "settings-2",     path: "/settings" }
  ].freeze

  def nav_items
    NAV_ITEMS.map { |item| item.merge(active: item[:key] == controller_name) }
  end
end
