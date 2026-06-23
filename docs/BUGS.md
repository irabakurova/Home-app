# Bug Tracker
# Family Meal Planner App

---

## Open Bugs

_None currently identified. See Stage 15 testing phase for systematic bug discovery._

---

## Resolved Bugs

### BUG-001: experimental_member_use warning in connection_web.dart
**Stage:** 15  
**Severity:** Low  
**Reported:** 2026-06-23  
**Status:** Fixed  
**Description:** `flutter analyze` reported warning about `DriftWebStorage.indexedDb` being experimental  
**Root Cause:** Missing `experimental_member_use` ignore comment on line 13  
**Fix:** Added `// ignore: deprecated_member_use, experimental_member_use` comment to `DriftWebStorage.indexedDb` call

---

## Bug Format

```
### BUG-XXX: Short description
**Stage:** X  
**Severity:** Critical / High / Medium / Low  
**Reported:** YYYY-MM-DD  
**Status:** Open / Fixed / Won't Fix  
**Description:** What happens and when  
**Root Cause:** What caused it  
**Fix:** What was changed  
```
