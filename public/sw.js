const CACHE_NAME = 'fleet-v6-1762508161';
const urlsToCache = [
  '/',
  '/assets/style.css',
  '/assets/app.js',
  '/manifest.json'
];

// Install Service Worker
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
  self.skipWaiting();
});

// Activate Service Worker
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Fetch Strategy: Network First, fallback to Cache
self.addEventListener('fetch', event => {
  // Skip API calls for network-first strategy
  if (event.request.url.includes('/api/')) {
    event.respondWith(
      fetch(event.request)
        .catch(() => {
          return new Response(JSON.stringify({ error: 'Network error' }), {
            headers: { 'Content-Type': 'application/json' }
          });
        })
    );
    return;
  }

  // For CSS/JS files: Network First (always get latest), fallback to cache
  if (event.request.url.includes('.css') || event.request.url.includes('.js')) {
    event.respondWith(
      fetch(event.request)
        .then(response => {
          // Cache the fresh response
          if (response && response.status === 200 && response.type === 'basic') {
            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then(cache => cache.put(event.request, responseToCache));
          }
          return response;
        })
        .catch(() => {
          // Network failed, try cache as fallback
          return caches.match(event.request);
        })
    );
    return;
  }

  // For other requests (images, fonts, etc): Cache First for performance
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }
        
        return fetch(event.request).then(response => {
          if (!response || response.status !== 200 || response.type !== 'basic') {
            return response;
          }
          
          const responseToCache = response.clone();
          caches.open(CACHE_NAME)
            .then(cache => cache.put(event.request, responseToCache));
          
          return response;
        });
      })
  );
});

// Listen for messages from the page (e.g. to clear cache on logout)
self.addEventListener('message', event => {
  try {
    const data = event.data || {};
    
    // Handle SKIP_WAITING for auto-updates
    if (data && data.type === 'SKIP_WAITING') {
      self.skipWaiting();
      return;
    }
    
    // Handle CLEAR_CACHES for logout
    if (data && data.type === 'CLEAR_CACHES') {
      // Delete all caches for a thorough cleanup
      caches.keys().then(keys => {
        return Promise.all(keys.map(k => caches.delete(k)));
      }).then(() => {
        // Optionally take control of clients after clearing
        return self.clients.matchAll().then(clients => {
          clients.forEach(client => {
            try { client.postMessage({ type: 'CACHES_CLEARED' }); } catch (e) {}
          });
        });
      });
    }
  } catch (e) {
    // swallow errors to avoid SW failing
    console.error('SW message handler error', e);
  }
});
