# Web Network Error Troubleshooting

If you encounter "Network Refuse" or `XMLHttpRequest error` while running on Flutter Web, it is usually due to one of the following reasons:

## 1. Browser Security (CORS)
Web browsers strictly enforce **CORS** (Cross-Origin Resource Sharing). Even if `jsonplaceholder` allows it, sometimes local development environments or specific browser settings can block requests.

**Solution for Testing:**
Run Chrome with disabled web security (ONLY for development):

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## 2. Browser Extensions
Ad-blockers or Privacy extensions (like AdGuard, uBlock) can block API requests.
**Solution:** Try running in Incognito mode or disable extensions.

## 3. Localhost Issues (If using Local API)
If you change the URL to `localhost`:
- Android Emulator: Use `10.0.2.2`
- Web: Use `localhost` or `127.0.0.1`
- **Important**: Your backend (Laravel/Node) MUST allow CORS from `localhost:<port>`.

## 4. Reset
Sometimes a clean build helps:
```bash
flutter clean
flutter pub get
flutter run -d chrome
```
