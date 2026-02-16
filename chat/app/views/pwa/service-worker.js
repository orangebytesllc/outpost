// Outpost Service Worker
// Handles push notifications and offline caching

// Push notification handler
self.addEventListener("push", async (event) => {
  if (!event.data) return;

  const { title, options } = await event.data.json();
  
  event.waitUntil(
    self.registration.showNotification(title, {
      ...options,
      icon: "/icon.png",
      badge: "/icon.png"
    })
  );
});

// Notification click handler - focus or open the relevant room
self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  const path = event.notification.data?.path || "/";

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then((clientList) => {
      // Try to focus an existing window with this path
      for (const client of clientList) {
        const clientPath = new URL(client.url).pathname;
        if (clientPath === path && "focus" in client) {
          return client.focus();
        }
      }

      // Try to focus any existing window and navigate it
      for (const client of clientList) {
        if ("focus" in client && "navigate" in client) {
          return client.focus().then(() => client.navigate(path));
        }
      }

      // Open a new window
      if (clients.openWindow) {
        return clients.openWindow(path);
      }
    })
  );
});

// Handle notification close (for analytics or cleanup if needed)
self.addEventListener("notificationclose", (event) => {
  // Could send analytics here if desired
});
